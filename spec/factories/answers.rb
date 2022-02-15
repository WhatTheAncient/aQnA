FactoryBot.define do
  factory :answer do
    sequence (:body) { |n| "MyText#{n}" }
    author { create(:user) }
    association :question
    files { [] }

    factory :answer_with_links do
      links { FactoryBot.create_list(:link_for_answer, 3) }
    end

    trait :invalid do
      body { nil }
    end
  end
end
