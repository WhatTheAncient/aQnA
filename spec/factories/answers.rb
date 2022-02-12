FactoryBot.define do
  factory :answer do
    sequence (:body) { |n| "MyText#{n}" }
    author { create(:user) }
    association :question
    files { [] }

    trait :invalid do
      body { nil }
    end
  end
end
