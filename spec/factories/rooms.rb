FactoryBot.define do
  factory :room do
    name { "Test Room" }
    status { :waiting }
    creator { create(:user) }  # userのファクトリを利用してcreatorを設定
    participant { nil }        # 最初は参加者がいない状態
  end
end
