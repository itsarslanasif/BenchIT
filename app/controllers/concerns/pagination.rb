module Pagination
  extend ActiveSupport::Concern
  include Pagy::Backend

  included do
    def pagination_for_chat_messages(conversation_id, page_no)
      @pagy, @messages = pagy(ConversationMessage.chat_messages(conversation_id), page: page_no || 1, items: 30)
    rescue StandardError
      @pagy = nil
    end
  end
end
