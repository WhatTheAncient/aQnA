FactoryBot.define do
  sequence :title do |n|
    "MyString#{n}"
  end
  factory :question do
    title { "MyString" }
    body { "MyText" }
    author { create(:user) }
    factory :question_with_answers do
      answers { FactoryBot.create_list(:answer, 5) }
    end
    files { [] }

    trait :invalid do
      title { nil }
    end
  end
end
