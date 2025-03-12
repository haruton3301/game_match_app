FactoryBot.define do
  factory :message do
    room { nil }
    user { nil }
    content { "MyText" }
  end
end
