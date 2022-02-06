require 'rails_helper'

feature 'User can delete answer', %q{
  As authenticated user
  I'd like to be able to delete my answer
} do

  given (:question) { create(:question_with_answers) }

  describe 'Authenticated user' do
    scenario 'who author of answer', js: true do
      answer = question.answers.first

      login(answer.author)
      visit question_path(question)

      expect(page).to have_content answer.body

      click_on 'Delete answer'

      expect(page).to have_content 'Your answer successfully deleted.'
      expect(page).to_not have_content answer.body
    end

    scenario 'who not author of answer' do
      user = create(:user)

      login(user)
      expect(page).to_not have_link 'Delete answer'
    end
  end

  scenario 'Unauthenticated user' do
    visit question_path(question)

    expect(page).to_not have_link 'Delete answer'
  end
end
