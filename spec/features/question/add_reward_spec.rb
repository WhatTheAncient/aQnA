require 'rails_helper'

feature 'User can add reward for best answer to question', %q{
  In order to praise best answer
  As an question's author
  I'd like to be able to add reward for best answer
} do

  describe 'User adds reward when asks question', js: true do
    given(:user) { create(:user) }

    background do
      login(user)
      visit new_question_path

      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'
    end

    scenario 'with valid data' do
      fill_in 'Reward name', with: 'Test reward'
      attach_file 'Reward image', "#{Rails.root}/public/img/reward.jpg"

      click_on 'Ask'

      expect(page).to have_content 'Test question'
      expect(page).to have_content 'text text text'
      within '.question' do
        within '.reward' do
          expect(page).to have_content 'Test reward'
        end
      end
    end

    scenario 'with invalid data' do
      attach_file 'Reward image', "#{Rails.root}/public/img/reward.jpg"
      click_on 'Ask'


      expect(page).to have_content "Reward name can't be blank"
    end
  end
end
