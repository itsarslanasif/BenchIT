module ProfileHelper
  def is_saved?(message)
    if Current.profile.saved_items.find_by(conversation_message_id:message.id)
      true
    else
      false
    end
  end
end
