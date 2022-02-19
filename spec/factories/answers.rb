FactoryBot.define do
  factory :answer do
    sequence (:body) { |n| "MyText#{n}" }
    author { create(:user) }
    association :question
    files { [] }
    votes { [] }

    factory :answer_with_links do
      links { FactoryBot.create_list(:link_for_answer, 3) }
    end

    factory :answer_with_files do
      files { [ Rack::Test::UploadedFile.new("#{Rails.root}/app/models/question.rb"),
                Rack::Test::UploadedFile.new("#{Rails.root}/app/models/answer.rb")] }
    end

    factory :answer_with_votes do
      votes { FactoryBot.create_list(:vote_for_answer, 3) }
    end

    trait :invalid do
      body { nil }
    end
  end
end
