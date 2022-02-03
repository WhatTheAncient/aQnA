FactoryBot.define do
  sequence :title do |n|
    "MyString#{n}"
  end
  factory :question do
    title
    body { "MyText" }


    trait :invalid do
      title { nil }
    end
    factory :question_with_answers do
      answers { FactoryBot.create_list(:answer, 5) }
    end
  end
end
