FactoryBot.define do
  sequence :name do |n|
    "Google#{n}"
  end
  factory :link do
    name
    url { "https://google.com" }
    factory :link_for_question do
      association :linkable, factory: :question
    end
    factory :link_for_answer do
      association :linkable, factory: :answer
    end
  end
end
