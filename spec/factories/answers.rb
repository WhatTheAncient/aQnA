FactoryBot.define do
  factory :answer do
    sequence (:body) { |n| "MyText#{n}" }
    author { create(:user) }
    association :question

    trait :invalid do
      body { nil }
    end
  end
end
