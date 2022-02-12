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

    describe 'with valid data' do
      background { fill_in 'Your answer', with: 'Test question answer' }

      scenario 'answer the question' do
        click_on 'Send answer'

        expect(page).to have_content 'Your answer successfully sent.'
        within('.answers') do
          expect(page).to have_content 'Test question answer'
        end
      end

        scenario 'asks a question with attached files' do
          attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
          click_on 'Send answer'

          expect(page).to have_link 'rails_helper.rb'
          expect(page).to have_link 'spec_helper.rb'
        end
      end

    scenario 'answer the question with invalid data' do
      click_on 'Send answer'

      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'Unauthenticated user tries to answer the question' do
    visit question_path(question)

    expect(page).to_not have_link 'Send answer'
    expect(page).to have_content 'You must sign in to answer the question'
    expect(page).to have_link 'sign in'
  end
end
