require 'rails_helper'

feature 'User can remove links from answer', %q{
  In order to remove useless info from my answer
  As an answer's author
  I'd like to be able to remove links
}, js: true do

  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, :with_links, question: question) }

  describe 'Authenticated user' do
    describe 'who author of question' do
      given(:user) { answer.author }
      background do
        login(user)
        visit question_path(question)
        answer.links.each do |link|
          expect(page).to have_content link.name
        end
      end

      scenario 'tries to delete question' do
        within('.answer-links') do
          within "#link-#{answer.links.first.id}" do
            click_on 'Delete link'
          end

          expect(page).to_not have_content answer.links.first.name
          answer.links.each do |link|
            expect(page).to have_content link.name unless link.name == answer.links.first.name
          end
        end
      end
    end

    describe 'who not author of question' do
      given(:user) { create(:user) }
      background do
        login(user)
        visit question_path(question)
        answer.links.each do |link|
          expect(page).to have_content link.name
        end
      end

      scenario 'tries to delete question' do
        within('.answer-links') do
          expect(page).to_not have_link 'Delete link'
        end
      end
    end
  end

  scenario 'Unauthenticated user tries to delete question' do
    visit question_path(question)
    within('.answer-links') do
      expect(page).to_not have_link 'Delete link'
    end
  end
end