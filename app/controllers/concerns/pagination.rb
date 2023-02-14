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

    def pagination_for_send_messages(page_no = 1)
      @pagy, @messages = pagy(ConversationMessage.send_messages, page: page_no, items: 2)
      [@pagy, @messages]
    end

    def pagination_for_save_messages(page_no = 1)
      @pagy, @messages = pagy(current_profile.saved_items.order(:created_at), page: page_no, items: 2)
      [@pagy, @messages]
    end

    def pagination_for_schedule_messages(page_no = 1)
      @pagy, @messages = pagy(current_profile.schedule_messages.order(:scheduled_at), page: page_no, items: 2)
      [@pagy, @messages]
    end
  end
end
