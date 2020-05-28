FactoryBot.define do
  factory :article do
    channel_id { 1 }
    subject { "MyString" }
    deliver_time { "2020-05-13 22:02:51" }
  end
end
