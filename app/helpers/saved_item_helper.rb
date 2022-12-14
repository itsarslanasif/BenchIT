module SavedItemHelper
  def saved?(message)
    Current.profile.saved_items.exists?(conversation_message_id: message.id)
  end
end
