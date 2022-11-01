FactoryBot.define do
  factory :chat_message do
    content { "MyText" }
    is_threaded { false }
    conversation { nil }
  end
end
