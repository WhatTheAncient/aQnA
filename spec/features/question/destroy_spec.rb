require 'rails_helper'

feature 'User can delete question', %q{
  As authenticated user
  I'd like to be able to delete my question
} do
  given (:question) { create(:question) }

  describe 'Authenticated user' do
    scenario 'who author of question' do
      login(question.author)
      visit question_path(question)

      expect(page).to have_content question.title
      expect(page).to have_content question.body

      click_on 'Delete question'

      expect(page).to have_content 'Your question successfully deleted.'
      expect(page).not_to have_content question.title
      expect(page).not_to have_content question.body
    end

    scenario 'who not author of question' do
      user = create(:user)

      login(user)
      expect(page).to_not have_link 'Delete question'
    end
  end

  scenario 'Unauthenticated user' do
    visit question_path(question)

    expect(page).to_not have_content 'Delete question'
  end
end
