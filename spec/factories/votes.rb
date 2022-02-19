FactoryBot.define do
  factory :vote do
    state { 1 }
    association :user
    factory :vote_for_question do
      user { create(:user) }
      association :votable, factory: :question
    end
    factory :vote_for_answer do
      user { create(:user) }
      association :votable, factory: :answer
    end
  end
end
