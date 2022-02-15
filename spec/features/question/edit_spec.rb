require 'rails_helper'

feature 'User can edit his question', %q{
  In order to update problem info
  As an author of question
  I'd like to be able to edit my question
}, js: true do

  given!(:question) { create(:question) }

  scenario 'Unauthenticated user can not edit answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  context 'Authenticated user' do
    describe 'as author of question' do
      let(:user) { question.author }

      background do
        login(user)
        visit question_path(question)
      end
      describe 'with valid data' do
        background do
          within '.question' do
            click_on 'Edit question'
            fill_in 'Title', with: 'Edited title'
            fill_in 'Body', with: 'Edited body'
          end
        end

        scenario 'edit question title and body' do
          within '.question' do
            click_on 'Save'

            expect(page).to_not have_content question.title
            expect(page).to_not have_content question.body
            expect(page).to have_content 'Edited title'
            expect(page).to have_content 'Edited body'
            expect(page).to_not have_selector 'textarea'
          end
        end

        scenario 'add files while editing' do
          within '.question' do
            attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]

            click_on 'Save'

            expect(page).to have_link 'rails_helper.rb'
            expect(page).to have_link 'spec_helper.rb'
          end
        end
      end

      scenario 'edit with invalid data' do
        within '.question' do
          click_on 'Edit question'
          fill_in 'Title', with: ''
          fill_in 'Body', with: ''
          click_on 'Save'

          expect(page).to have_content "Title can't be blank"
          expect(page).to have_content "Body can't be blank"
          expect(page).to have_field 'Title'
          expect(page).to have_field 'Body'
        end
      end
    end

    scenario 'as not author of question' do
      user = create(:user)
      login(user)
      visit question_path(question)

      expect(page).to_not have_link 'Edit'
    end
  end
end
