require 'rails_helper'

feature 'User can delete answer', %q{
  As authenticated user
  I'd like to be able to delete my answer
} do

  given (:question) { create(:question_with_answers) }

  describe 'Authenticated user' do
    scenario 'who author of answer' do
      login(question.answers.first.author)

      visit question_path(question)

      click_on 'Delete answer'

      expect(page).to have_content 'Your answer successfully deleted.'
    end

    scenario 'who not author of answer' do
      user = create(:user)

      login(user)
      expect(page).to_not have_content 'Delete question'
    end
  end

  scenario 'Unauthenticated user' do
    visit question_path(question)

    expect(page).to_not have_content 'Delete question'
  end
end
