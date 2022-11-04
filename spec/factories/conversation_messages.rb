FactoryBot.define do
  factory :conversation_message do
    content { "MyText" }
    is_threaded { false }
    conversation { nil }
  end
end
