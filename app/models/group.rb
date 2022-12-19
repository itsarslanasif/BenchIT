class Group < ApplicationRecord
  has_one :bench_conversation, as: :conversationable, dependent: :destroy
end
