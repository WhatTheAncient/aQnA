require 'rails_helper'

feature 'User can see list of achieved rewards', %q{
  In order to see my achievements
  As user
  I'd like to be able to see list of my rewards
} do

  describe 'Authenticated user' do
    scenario 'who has rewards' do
      user = create :user, rewards: create_list(:reward_with_question, 5)
      login(user)
      visit root_path
      click_on 'My rewards'
      user.rewards.each do |reward|
        expect(page).to have_content reward.name
        expect(page).to have_content reward.question.title
        expect(page).to have_selector '.reward-image'
      end
    end

    scenario 'who has not rewards' do
      user = create :user
      login(user)
      visit root_path
      expect(page).to_not have_link 'My rewards'
    end
  end

  scenario 'Unauthenticated user' do
    visit root_path
    expect(page).to_not have_link 'My rewards'
  end
end
