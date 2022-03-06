require 'rails_helper'

feature 'User can see question and list of answers', %q{
  In order to find right answer
  As user
  I'd like to be able to see list of answers for question
} do

  scenario 'User go to page with all questions' do
    question = create(:question, :with_answers)

    visit question_path(question)

    expect(page).to have_content(question.title)
    expect(page).to have_content(question.body)

    question.answers.each do |answer|
      expect(page).to have_content answer.body
    end
  end
end
