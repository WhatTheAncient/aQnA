require 'rails_helper'

feature 'User can (un-)subscribe (from)on question', %q{
  In order to get notifications about new answers
  As authenticated user
  I'd like to be able to (un-)subscribe (from)on question.
}, js: true do
  let(:question) { create(:question) }

  describe 'Authenticated user' do
    describe 'as author of question' do
      let(:user) { question.author }

      before do
        login(user)
        visit question_path(question)
      end

      scenario 'unsubscribe from question' do
        expect(page).to have_link 'Unsubscribe'

        click_on 'Unsubscribe'

        expect(page).to_not have_link 'Unsubscribe'
        expect(page).to have_content 'You successfully unsubscribed from question'
        expect(page).to have_link 'Subscribe'
      end
    end

    describe 'as other user' do
      let(:user) { create(:user) }

      before do
        login(user)
      end

      scenario 'subscribe on question' do
        visit question_path(question)

        expect(page).to have_link 'Subscribe'

        click_on 'Subscribe'

        expect(page).to_not have_link 'Subscribe'
        expect(page).to have_content 'You successfully subscribed on question'
        expect(page).to have_link 'Unsubscribe'
      end

      scenario 'unsubscribe from question' do
        create(:subscription, user: user, question: question)
        visit question_path(question)

        expect(page).to have_link 'Unsubscribe'

        click_on 'Unsubscribe'

        expect(page).to_not have_link 'Unsubscribe'
        expect(page).to have_content 'You successfully unsubscribed from question'
        expect(page).to have_link 'Subscribe'
      end
    end
  end

  scenario 'Unauthenticate user' do
    visit question_path(question)

    expect(page).to_not have_link 'Subscribe'
    expect(page).to_not have_link 'Unsubscribe'
  end
end
