require 'rails_helper'

feature 'User can create question', %q{
  In order get answers from a community
  As authenticated user
  I'd like to be able to create question
} do

  given (:user) { create(:user) }

  describe 'Authenticated user' do
    background do
      login(user)

      visit questions_path
      click_on 'Ask question'
    end

    describe 'with valid data' do
      background do
        fill_in 'Title', with: 'Test question'
        fill_in 'Body', with: 'Test text Test text'
      end

      scenario 'asks a question' do
        click_on 'Ask'

        expect(page).to have_content 'Your question successfully created.'
        expect(page).to have_content 'Test question'
        expect(page).to have_content 'Test text Test text'
      end

      scenario 'asks a question with attached files' do
        attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Ask'

        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end
    scenario 'asks a question with errors' do
      click_on 'Ask'

      expect(page).to have_content "Title can't be blank"
    end
  end

  scenario 'Unauthenticated user tries to ask a question' do
    visit questions_path
    click_on 'Ask question'

    expect(page).to have_content 'You need to sign in or sign up before continuing'
  end
end
