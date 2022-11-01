FactoryBot.define do
  factory :chat_channel do
    name { "MyString" }
    description { "MyText" }
    is_private { false }
  end
end
