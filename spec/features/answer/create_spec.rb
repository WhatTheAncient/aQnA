require 'rails_helper'

feature 'User can answer the question', %q{
  In order to answer the question
  As authenticated user
  I'd like to be able to create answer
  When I'm on question page
}, js: true do

  given (:question) { create(:question) }

  describe 'Authenticated user' do
    given (:user) { create(:user) }

    background do
      login(user)

      visit question_path(question)
    end

    scenario 'answer the question' do
      fill_in 'Your answer', with: 'Test question answer'

      click_on 'Send answer'

      expect(page).to have_content 'Your answer successfully sent.'
      within('.answers') do
        expect(page).to have_content 'Test question answer'
      end
    end

    scenario 'answer the question with invalid data' do
      click_on 'Send answer'

      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'Unauthenticated user tries to answer the question' do
    visit question_path(question)
    fill_in 'Your answer', with: 'Unauthenticated user answer'

    click_on 'Send answer'
    expect(page).to have_content 'You need to sign in or sign up before continuing'
  end
end
