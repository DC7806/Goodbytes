FactoryBot.define do
  factory :invite do
    item { nil }
    token { "MyString" }
    sender_id { nil }
    receiver_id { nil }
  end
end
