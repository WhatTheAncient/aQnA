FactoryBot.define do
  sequence :body do |n|
    body { "MyText#{n}" }
  end
  factory :answer do
    body { "MyText" }
    association :question

    trait :invalid do
      body { nil }
    end
  end
end
