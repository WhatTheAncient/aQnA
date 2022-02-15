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

    factory :question_with_links do
      links { FactoryBot.create_list(:link_for_question, 3) }
    end

    trait :invalid do
      title { nil }
    end
  end
end
