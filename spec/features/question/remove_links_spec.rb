require 'rails_helper'

feature 'User can remove links from question', %q{
  In order to remove useless info from my question
  As an question's author
  I'd like to be able to remove links
}, js: true do

  given(:question) { create(:question_with_links) }

  describe 'Authenticated user' do
    describe 'who author of question' do
      given(:user) { question.author }
      background do
        login(user)
        visit question_path(question)
        question.links.each do |link|
          expect(page).to have_content link.name
        end
      end

      scenario 'tries to delete question' do
        within '.question-links' do
          within "#link-#{question.links.first.id}" do
            click_on 'Delete link'
          end

          expect(page).to_not have_content question.links.first.name
          question.links.each do |link|
            expect(page).to have_content link.name unless link.name == question.links.first.name
          end
        end
      end
    end

    describe 'who not author of question' do
      given(:user) { create(:user) }
      background do
        login(user)
        visit question_path(question)
        question.links.each do |link|
          expect(page).to have_content link.name
        end
      end

      scenario 'tries to delete question' do
        within('.question-links') do
          expect(page).to_not have_link 'Delete link'
        end
      end
    end
  end

  scenario 'Unauthenticated user tries to delete question' do
    visit question_path(question)
    within('.question-links') do
      expect(page).to_not have_link 'Delete link'
    end
  end
end