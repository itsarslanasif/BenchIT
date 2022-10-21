# This class creates both outgoing messages from chatwoot and echo outgoing messages based on the flag `outgoing_echo`
# Assumptions
# 1. Incase of an outgoing message which is echo, source_id will NOT be nil,
#    based on this we are showing "not sent from chatwoot" message in frontend
#    Hence there is no need to set user_id in message for outgoing echo messages.

class Messages::Facebook::MessageBuilder < Messages::Messenger::MessageBuilder
  attr_reader :response

  def initialize(response, inbox, outgoing_echo: false)
    super()
    @response = response
    @inbox = inbox
    @outgoing_echo = outgoing_echo
    @sender_id = (@outgoing_echo ? @response.recipient_id : @response.sender_id)
    @message_type = (@outgoing_echo ? :outgoing : :incoming)
    @attachments = (@response.attachments || [])
  end

  def perform
    # This channel might require reauthorization, may be owner might have changed the fb password
    return if @inbox.channel.reauthorization_required?

    ActiveRecord::Base.transaction do
      build_contact
      build_message
    end
    ensure_contact_avatar
  rescue Koala::Facebook::AuthenticationError
    @inbox.channel.authorization_error!
  rescue StandardError => e
    ChatwootExceptionTracker.new(e, account: @inbox.account).capture_exception
    true
  end

  private

  def contact
    @contact ||= @inbox.contact_inboxes.find_by(source_id: @sender_id)&.contact
  end

  def build_contact
    return if contact.present?

    @contact = Contact.create!(contact_params.except(:remote_avatar_url))
    @contact_inbox = ContactInbox.find_or_create_by!(contact: contact, inbox: @inbox, source_id: @sender_id)
  end

  def build_message
    @message = conversation.messages.create!(message_params)

    @attachments.each do |attachment|
      process_attachment(attachment)
    end
  end

  def ensure_contact_avatar
    return if contact_params[:remote_avatar_url].blank?
    return if @contact.avatar.attached?

    Avatar::AvatarFromUrlJob.perform_later(@contact, contact_params[:remote_avatar_url])
  end

  def conversation
    @conversation ||= Conversation.find_by(conversation_params) || build_conversation
  end

  def build_conversation
    @contact_inbox ||= contact.contact_inboxes.find_by!(source_id: @sender_id)
    Conversation.create!(conversation_params.merge(
                           contact_inbox_id: @contact_inbox.id
                         ))
  end

  def location_params(attachment)
    lat = attachment['payload']['coordinates']['lat']
    long = attachment['payload']['coordinates']['long']
    {
      external_url: attachment['url'],
      coordinates_lat: lat,
      coordinates_long: long,
      fallback_title: attachment['title']
    }
  end

  def fallback_params(attachment)
    {
      fallback_title: attachment['title'],
      external_url: attachment['url']
    }
  end

  def conversation_params
    {
      account_id: @inbox.account_id,
      inbox_id: @inbox.id,
      contact_id: contact.id
    }
  end

  def message_params
    {
      account_id: conversation.account_id,
      inbox_id: conversation.inbox_id,
      message_type: @message_type,
      content: response.content,
      source_id: response.identifier,
      sender: @outgoing_echo ? nil : contact
    }
  end

  def process_contact_params_result(result)
    {
      name: "#{result['first_name'] || 'John'} #{result['last_name'] || 'Doe'}",
      account_id: @inbox.account_id,
      remote_avatar_url: result['profile_pic'] || ''
    }
  end

  def contact_params
    begin
      k = Koala::Facebook::API.new(@inbox.channel.page_access_token) if @inbox.facebook?
      result = k.get_object(@sender_id) || {}
    rescue Koala::Facebook::AuthenticationError
      @inbox.channel.authorization_error!
      raise
    rescue Koala::Facebook::ClientError => e
      result = {}
      # OAuthException, code: 100, error_subcode: 2018218, message: (#100) No profile available for this user
      # We don't need to capture this error as we don't care about contact params in case of echo messages
      ChatwootExceptionTracker.new(e, account: @inbox.account).capture_exception unless @outgoing_echo
    rescue StandardError => e
      result = {}
      ChatwootExceptionTracker.new(e, account: @inbox.account).capture_exception
    end
    process_contact_params_result(result)
  end
end
