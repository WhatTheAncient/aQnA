require 'rails_helper'

feature 'Authenticated user can log out', %q{
  In order to sign in another account
  As authenticated user
  I'd like to be able to log out
} do
  scenario do
    User.create!(email: 'user@test.com', password: '12345678')
    visit new_user_session_path

    fill_in 'Email', with: 'user@test.com'
    fill_in 'Password', with: '12345678'
    click_on 'Log in'

    click_on 'Log out'

    expect(page).to have_content 'Log out successfully.'
  end

end