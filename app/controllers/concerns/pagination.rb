class PaginationError < StandardError; end

module Pagination
  extend ActiveSupport::Concern
  include Pagy::Backend

  included do
    def pagination_for_chat_messages(conversation_id, page_no)
      @pagy, @messages = pagy(ConversationMessage.chat_messages(conversation_id), page: page_no || 1, items: 30)
      @messages = @messages.reverse
      [@pagy, @messages]
    rescue StandardError
      @pagy = nil
    end

    def pagination_for_bench_channels(bench_channels, page_no)
      @pagy, @bench_channels = pagy(bench_channels, page: page_no, items: 50)
      [@pagy, @bench_channels]
    rescue Pagy::OverflowError, Pagy::VariableError => e
      raise PaginationError, e.message
    end
  end
end
