require 'rails_helper'

feature 'User can create question', %q{
  In order get answers from a community
  As authenticated user
  I'd like to be able to create question
} do

  given (:user) { User.create!(email: 'user@test.com', password: '12345678') }

  scenario 'Authenticated user asks a question' do
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'

    visit questions_path
    click_on 'Ask question'
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'Test text Test text'
    click_on 'Ask'

    expect(page).to have_content 'Your question successfully created.'
    expect(page).to have_content 'Test question'
    expect(page).to have_content 'Test text Test text'
  end

  scenario 'Authenticated user asks a question with errors' do
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'

    visit questions_path
    click_on 'Ask question'

    click_on 'Ask'

    expect(page).to have_content "Title can't be blank"
  end

  scenario 'Unauthenticated user tries to ask a question' do
    visit questions_path
    click_on 'Ask question'

    expect(page).to have_content 'You need to sign in or sign up before continuing'
  end
end
