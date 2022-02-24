require 'rails_helper'

feature 'User can create question', %q{
  In order get answers from a community
  As authenticated user
  I'd like to be able to create question
} do

  given (:user) { create(:user) }

  context 'Authenticated user' do
    background do
      login(user)

      visit questions_path
      click_on 'Ask question'
    end

    context 'with valid data' do
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

  context 'multiple sessions', js: true do
    scenario "question appears on another user's page" do
      Capybara.using_session('question_author') do
        login(user)
        visit questions_path
        click_on 'Ask question'
      end

      Capybara.using_session('guest') do
        visit questions_path
      end

      Capybara.using_session('question_author') do
        fill_in 'Title', with: 'Test Title'
        fill_in 'Body', with: 'Test Body'

        click_on 'Ask'

        expect(page).to have_content 'created'
        expect(page).to have_content 'Test Title'
        expect(page).to have_content 'Test Body'
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'Test Title'
        expect(page).to have_content 'Test Body'
      end
    end
  end

  scenario 'Unauthenticated user tries to ask a question' do
    visit questions_path
    click_on 'Ask question'

    expect(page).to have_content 'You need to sign in or sign up before continuing'
  end
end
