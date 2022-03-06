FactoryBot.define do
  factory :answer do
    sequence (:body) { |n| "MyText#{n}" }
    author { create(:user) }
    association :question
    files { [] }
    votes { [] }

    trait :invalid do
      body { nil }
    end

    trait :with_links do
      links { FactoryBot.create_list(:link_for_answer, 3) }
    end

    trait :with_files do
      files { [ Rack::Test::UploadedFile.new("#{Rails.root}/app/models/question.rb"),
                Rack::Test::UploadedFile.new("#{Rails.root}/app/models/answer.rb")] }
    end

    trait :with_comments  do
      comments { FactoryBot.create_list(:comment_for_answer, 3) }
    end
  end
end
