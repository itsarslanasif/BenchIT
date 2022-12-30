module Cablable
  extend ActiveSupport::Concern

  def append_conversation_type_and_id(result)
    result[:bench_conversation_type] = bench_conversation.conversationable_type
    result[:bench_conversation_id] = bench_conversation.conversationable_id
  end
end
