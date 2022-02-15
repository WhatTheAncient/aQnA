FactoryBot.define do
  factory :reward do
    sequence :name do |n|
      "Test Reward ##{n}"
    end
    association :user
    association :question
    factory :reward_with_question do
      question { create(:question) }
    end
  end
end
