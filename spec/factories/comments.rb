FactoryBot.define do
  factory :comment do
    sequence :body do |n|
      "Comment Body ##{n}"
    end
    author { create(:user) }
    commentable {  }

    factory :comment_for_question do
      association :commentable, factory: :question
    end

    factory :comment_for_answer do
      association :commentable, factory: :answer
    end

    trait :invalid do
      body { nil }
    end
  end
end
