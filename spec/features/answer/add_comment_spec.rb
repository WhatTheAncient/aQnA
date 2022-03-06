require 'rails_helper'

feature 'User can comment the answer', %q{
  In order to comment the answer
  As authenticated user
  I'd like to be able to comment the answer on question's page
}, js: true do

  given(:question) { create(:question, :with_answers) }
  given(:answer) { question.answers[1] }

  describe 'Authenticated user comment the answer' do
    given(:user) { create(:user) }

    background do
      login(user)
      visit question_path(question)
    end
    scenario 'with valid data' do
      within "#answer-#{answer.id}" do
        click_on 'Add comment'
        fill_in 'Body', with: 'Test Comment'

        click_on 'Comment'

        expect(page).to_not have_content 'Body'
        expect(page).to have_content "Author: #{user.email}"
        expect(page).to have_content 'Test Comment'
      end
    end

    context 'multiple sessions', js: true do
      scenario "comment appears on another user's page" do
        Capybara.using_session('user') do
          login(user)
          visit question_path(question)
        end

        Capybara.using_session('guest') do
          visit question_path(question)
        end

        Capybara.using_session('user') do
          within "#answer-#{answer.id}" do
            click_on 'Add comment'
            fill_in 'Body', with: 'Test question comment'

            click_on 'Comment'

            expect(page).to have_content 'Test question comment'
          end
        end

        Capybara.using_session('guest') do
          within "#answer-#{answer.id}" do
            expect(page).to have_content 'Test question comment'
            end
        end
      end
    end

    scenario 'with invalid data' do
      within "#answer-#{answer.id}" do
        click_on 'Add comment'
        click_on 'Comment'

        expect(page).to have_content "Body can't be blank"
      end
    end
  end

  scenario 'Unauthenticated user tries to comment the question' do
    visit questions_path(question)

    expect(page).to_not have_content 'Add comment'
  end
end
