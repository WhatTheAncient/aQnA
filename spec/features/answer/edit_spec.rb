require 'rails_helper'

feature 'User can edit his answer', %q{
  In order to correct mistakes
  As an author of answer
  I'd like to be able to edit my answer
}, js: true do

  given!(:answer) { create(:answer) }
  given!(:question) { answer.question }

  scenario 'Unauthenticated user can not edit answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  context 'Authenticated user' do
    describe 'as author of answer' do
      let(:user) { answer.author }

      background do
        login(user)
        visit question_path(question)
      end
      describe 'with valid data' do
        background { click_on 'Edit' }

        scenario 'edit with valid data' do
          within '.answers' do
            fill_in 'Your answer', with: 'edited answer'
            click_on 'Save'

            expect(page).to_not have_content answer.body
            expect(page).to have_content 'edited answer'
            expect(page).to_not have_selector 'textarea'
          end
        end

        scenario 'add files while editing' do
          within '.answers' do
            attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
            click_on 'Save'

            expect(page).to have_link 'rails_helper.rb'
            expect(page).to have_link 'spec_helper.rb'
          end
        end
      end

      scenario 'edit with invalid data' do
        click_on 'Edit'
        within '.answers' do
          fill_in 'Your answer', with: ''
          click_on 'Save'

          expect(page).to have_content "Body can't be blank"
          expect(page).to have_field 'Your answer'
        end
      end
    end

    scenario 'as not author of answer' do
      user = create(:user)
      login(user)
      visit question_path(question)

      expect(page).to_not have_link 'Edit'
    end
  end
end
