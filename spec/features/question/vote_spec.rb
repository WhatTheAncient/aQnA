require 'rails_helper'

feature 'User can vote for question', %q{
  In order to point at usefull question
  As authenticated user
  I'd like to be able to vote for another question
}, js: true do
  let!(:question) { create(:question) }

  describe 'Authenticated user' do
    scenario 'As author of question tries to vote for his question' do
      user = question.author
      login(user)
      visit questions_path

      within '.question-vote' do
        expect(page).to_not have_content 'Good'
        expect(page).to_not have_content 'Bad'
      end
    end

    describe 'As not author of question' do
      let(:user) { create(:user) }

      background do
        login(user)
        visit questions_path
      end

      scenario 'likes question first time' do
        within '.question-vote' do
          expect(page).to have_content 'Good'
          expect(page).to have_content 'Bad'

          click_on 'Good'

          expect(page).to have_content 'Rating: 1'
        end
      end

      scenario 'dislikes question first time' do
        within '.question-vote' do
          expect(page).to have_content 'Good'
          expect(page).to have_content 'Bad'

          click_on 'Bad'

          expect(page).to have_content 'Rating: -1'
        end
      end

      describe 'after voting' do
        background do
          within '.question-vote' do
            expect(page).to have_content 'Good'
            expect(page).to have_content 'Bad'

            click_on 'Good'

            visit questions_path
          end
        end

        scenario 'tries to vote for question second time' do
          within '.question-vote' do
            expect(page).to_not have_content 'Good'
            expect(page).to_not have_content 'Bad'
          end
        end

        scenario 'cancel vote' do
          within '.question-vote' do
            expect(page).to have_content 'Cancel vote'
            expect(page).to have_content 'Rating: 1'

            click_on 'Cancel vote'

            expect(page).to_not have_content 'Cancel vote'
            expect(page).to have_content 'Rating: 0'
          end
        end
      end
    end
  end

  scenario 'Unauthenticated user tries to vote for question' do
    visit questions_path
    within '.question-vote' do
      expect(page).to_not have_content 'Good'
      expect(page).to_not have_content 'Bad'
    end
  end
end
