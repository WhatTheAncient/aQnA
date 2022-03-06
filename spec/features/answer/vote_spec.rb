require 'rails_helper'

feature 'User can vote for Answer', %q{
  In order to show my opinion about answer
  As authenticated user,
  I'd like to be able to vote for another answer
}, js: true do
  let!(:question) { create(:question, :with_answers) }
  let(:answer) { question.answers[1] }

  describe 'Authenticated user' do
    scenario 'As author of answer tries to vote for his answer' do
      user = answer.author
      login(user)
      visit question_path(question)

      within "#answer-#{answer.id}" do
        within '.answer-vote' do
          expect(page).to_not have_content 'Good'
          expect(page).to_not have_content 'Bad'
        end
      end
    end

    describe 'As not author of answer' do
      let(:user) { create(:user) }

      background do
        login(user)
        visit question_path(question)
      end

      scenario 'likes answer first time' do
        within "#answer-#{answer.id}" do
          within '.answer-vote' do
            expect(page).to have_content 'Good'
            expect(page).to have_content 'Bad'

            click_on 'Good'

            expect(page).to have_content 'Rating: 1'
          end
        end
      end

      scenario 'dislikes answer first time' do
        within "#answer-#{answer.id}" do
          within '.answer-vote' do
            expect(page).to have_content 'Good'
            expect(page).to have_content 'Bad'

            click_on 'Bad'

            expect(page).to have_content 'Rating: -1'
          end
        end
      end
      describe 'after voting' do
        background do
          within "#answer-#{answer.id}" do
            within '.answer-vote' do
              expect(page).to have_content 'Good'
              expect(page).to have_content 'Bad'

              click_on 'Good'

              visit question_path(question)
            end
          end
        end

        scenario 'tries to vote for answer second time' do
          within "#answer-#{answer.id}" do
            within '.answer-vote' do
              expect(page).to_not have_content 'Good'
              expect(page).to_not have_content 'Bad'
            end
          end
        end

        scenario 'cancel his vote' do
          within "#answer-#{answer.id}" do
            within '.answer-vote' do
              expect(page).to have_content 'Cancel vote'
              expect(page).to have_content 'Rating: 1'

              click_on 'Cancel vote'

              expect(page).to_not have_content 'Cacncel vote'
              expect(page).to have_content 'Rating: 0'
            end
          end
        end
      end
    end
  end

  scenario 'Unauthenticated user tries to vote for answer' do
    visit question_path(question)
    within "#answer-#{answer.id}" do
      within '.answer-vote' do
        expect(page).to_not have_content 'Good'
        expect(page).to_not have_content 'Bad'
      end
    end
  end
end
