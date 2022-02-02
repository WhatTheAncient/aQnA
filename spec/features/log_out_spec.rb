require 'rails_helper'

feature 'Authenticated user can log out', %q{
  In order to sign in another account
  As authenticated user
  I'd like to be able to log out
} do
  scenario do
    user = create(:user)
    login(user)

    click_on 'Log out'

    expect(page).to have_content 'Log out successfully.'
  end

end