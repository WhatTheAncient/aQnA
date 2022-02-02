require 'rails_helper'

feature 'User can sign up', %q{
  In order to sign in
  As an unregistered user
  I'd like to be able to sign up
} do

  given(:user) { User.create!(email: 'registered@test.com', password: 'password') }

  background { visit new_user_registration_path }

  scenario 'Unregistered user tries to sign up with correct passwords' do
    fill_in 'Email', with: 'new_user@test.com'
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '12345678'
    click_on 'Sign up'

    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end

  scenario 'Unregistered user tries to sign up with incorrect unmatched passwords' do
    fill_in 'Email', with: 'new_user@test.com'
    fill_in 'Password', with: '123'
    fill_in 'Password confirmation', with: '1234'
    click_on 'Sign up'

    expect(page).to have_content "Password confirmation doesn't match"
    expect(page).to have_content 'Password is too short'
  end

  scenario 'Registered user tries to sign up' do
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    fill_in 'Password confirmation', with: user.password
    click_on 'Sign up'

    expect(page).to have_content 'Email has already been taken'
  end

end