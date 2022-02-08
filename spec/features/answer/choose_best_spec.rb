require 'rails_helper'

feature "User can choose best answer", %q{
  In order to help other users find solution
  As author of question
  I'd like to be able to choose best answer
}, js: true do
  given!(:question) { create(:question_with_answers) }

  describe 'As authenticated user' do
    describe 'Author of question tries to choose the best answer' do
      background do
        login(question.author)
        visit question_path(question)
      end

      scenario 'if best answer does not chosen' do
        answer = question.answers[2]

        within "#answer-#{answer.id}" do
          click_on 'Choose as the best'
        end

        expect(page).to have_content answer.body
        expect(page).to have_selector '.best-answer'
      end

      scenario 'id best answer already chosen' do
        old_best_answer = question.answers[4]
        question.update(best_answer: old_best_answer)
        new_best_answer = question.answers[2]

        within "#answer-#{new_best_answer.id}" do
          click_on 'Choose as the best'
        end

        expect(page).to have_selector '.best-answer'

        within('.best-answer') do
          expect(page).to_not have_content old_best_answer.body
          expect(page).to have_content new_best_answer.body
        end
      end
    end

    scenario  'Not author of question tries to choose the best answer' do
      user = create(:user)
      login(user)
      visit question_path(question)

      expect(page).to_not have_link 'Choose as the best'
    end
  end

  scenario 'Unauthenticated user tries to choose the best answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Choose as the best'
  end
end

