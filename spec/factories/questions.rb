FactoryBot.define do
  sequence :title do |n|
    "MyString#{n}"
  end
  factory :question do
    title { "MyString" }
    body { "MyText" }
    author { create(:user) }

    trait :invalid do
      title { nil }
    end

    trait :with_answers do
      answers { FactoryBot.create_list(:answer, 5) }
    end

    trait :with_links do
      links { FactoryBot.create_list(:link_for_answer, 3) }
    end

    trait :with_files do
      files { [ Rack::Test::UploadedFile.new("#{Rails.root}/app/models/question.rb"),
                Rack::Test::UploadedFile.new("#{Rails.root}/app/models/answer.rb")] }
    end

    trait :with_comments  do
      comments { FactoryBot.create_list(:comment_for_question, 3) }
    end

    trait :with_votes do
      votes { FactoryBot.create_list(:vote_for_question, 3) }
    end
  end
end
