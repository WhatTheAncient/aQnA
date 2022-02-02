require 'rails_helper'

feature 'User can sign up', %q{
  In order to sign in
  As an unregistered user
  I'd like to be able to sign up
} do
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

    click_on 'Sign up'

    expect(page).to have_content "Password can't be blank"
  end

  scenario 'Registered user tries to sign up' do
    user = create(:user)

    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    fill_in 'Password confirmation', with: user.password
    click_on 'Sign up'

    expect(page).to have_content 'Email has already been taken'
  end
end
