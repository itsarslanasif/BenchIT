# loading installation configs
GlobalConfig.clear_cache
ConfigLoader.new.process
## Seeds productions
if Rails.env.production?
  # Setup Onboarding flow
  ::Redis::Alfred.set(::Redis::Alfred::CHATWOOT_INSTALLATION_ONBOARDING, true)
end
## Seeds for Local Development
unless Rails.env.production?
  # Enables creating additional accounts from dashboard
  installation_config = InstallationConfig.find_by(name: 'CREATE_NEW_ACCOUNT_FROM_DASHBOARD')
  installation_config.value = true
  installation_config.save!
  GlobalConfig.clear_cache
  account = Account.create!(
    name: 'Acme Inc'
  )
  secondary_account = Account.create!(
    name: 'Acme Org'
  )
  user1 = User.new(name: 'faisal', email: 'faisal@gmail.com', password: 'Password1!', type: 'SuperAdmin')
  user1.skip_confirmation!
  user1.save!
  user2 = User.new(name: 'arshad', email: 'arshad@gmail.com', password: 'Password1!', type: 'SuperAdmin')
  user2.skip_confirmation!
  user2.save!
  user3 = User.new(name: 'muaz', email: 'muaz@gmail.com', password: 'Password1!', type: 'SuperAdmin')
  user3.skip_confirmation!
  user3.save!
  user = User.new(name: 'John', email: 'john@acme.inc', password: 'Password1!', type: 'SuperAdmin')
  user.skip_confirmation!
  user.save!
  BenchChannel.create(name: 'dev', description: 'dev', creator_id: 1)
  BenchConversation.create(conversationable_type: 'BenchChannel', conversationable_id: 1)
  ChannelParticipant.create(permission: true,user_id: 1 , bench_channel_id: 1)
  ChannelParticipant.create(permission: true,user_id: 2 , bench_channel_id: 1)
  ConversationMessage.create(content: 'Hi Dev Channel from faisal', is_threaded: false, bench_conversation_id: 1, sender_id: 1)
  ConversationMessage.create(content: 'Hi Dev Channel from arshad', is_threaded: false, bench_conversation_id: 1, sender_id: 2)
  Group.create(id: 1)
  BenchConversation.create(conversationable_type: 'Group', conversationable_id: 1)
  UserGroup.create(user_id: 1, group_id: 1)
  UserGroup.create(user_id: 2, group_id: 1)
  UserGroup.create(user_id: 3, group_id: 1)
  ConversationMessage.create(content: 'Hi Group from faisal', is_threaded: false, bench_conversation_id: 2, sender_id: 1)
  ConversationMessage.create(content: 'Hi Group from arshad', is_threaded: false, bench_conversation_id: 2, sender_id: 2)
  ConversationMessage.create(content: 'Hi Group from muaz', is_threaded: false, bench_conversation_id: 2, sender_id: 3)
  BenchConversation.create(conversationable_type: 'User', conversationable_id: 1, sender_id: 4)
  ConversationMessage.create(content: 'Hi User from john', is_threaded: false, bench_conversation_id: 3, sender_id: 4)
  ConversationMessage.create(content: 'Hi User from faisal', is_threaded: false, bench_conversation_id: 3, sender_id: 1)
  AccountUser.create!(
    account_id: account.id,
    user_id: user.id,
    role: :administrator
  )
  AccountUser.create!(
    account_id: secondary_account.id,
    user_id: user.id,
    role: :administrator
  )
  web_widget = Channel::WebWidget.create!(account: account, website_url: 'https://acme.inc')
  inbox = Inbox.create!(channel: web_widget, account: account, name: 'Acme Support')
  InboxMember.create!(user: user, inbox: inbox)
  contact = Contact.create!(name: 'jane', email: 'jane@example.com', phone_number: '+2320000', account: account)
  contact_inbox = ContactInbox.create!(inbox: inbox, contact: contact, source_id: user.id, hmac_verified: true)
  conversation = Conversation.create!(
    account: account,
    inbox: inbox,
    status: :open,
    assignee: user,
    contact: contact,
    contact_inbox: contact_inbox,
    additional_attributes: {}
  )
  # sample email collect
  Seeders::MessageSeeder.create_sample_email_collect_message conversation
  Message.create!(content: 'Hello', account: account, inbox: inbox, conversation: conversation, message_type: :incoming)
  # sample card
  Seeders::MessageSeeder.create_sample_cards_message conversation
  # input select
  Seeders::MessageSeeder.create_sample_input_select_message conversation
  # form
  Seeders::MessageSeeder.create_sample_form_message conversation
  # articles
  Seeders::MessageSeeder.create_sample_articles_message conversation
  # csat
  Seeders::MessageSeeder.create_sample_csat_collect_message conversation
  CannedResponse.create!(account: account, short_code: 'start', content: 'Hello welcome to chatwoot.')
end
