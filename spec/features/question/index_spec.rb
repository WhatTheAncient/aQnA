require 'rails_helper'

feature 'User can see list of questions', %q{
  In order to find similar question
  As user
  I'd like to be able to see list of all questions
} do

  scenario 'User go to page with all questions' do
    questions = create_list(:question, 3)

    visit questions_path

    questions.each do |question|
      expect(page).to have_content question.title
      expect(page).to have_content question.body
    end
  end
end
