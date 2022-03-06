require 'rails_helper'

feature 'User can add links to answer', %q{
  In order to provide additional info to my answer
  As an answer's author
  I'd like to be able to add links
} do

  given(:question) { create :question, :with_answers }

  describe  'User adds links when answers the question', js: true do
    given(:user) { create(:user) }
    given(:github_url) { 'https://github.com/WhatTheAncient' }
    given(:school_url) { 'https://thinknetica.com' }

    background do
      login(user)
      visit question_path(question)

      fill_in 'Your answer', with: 'text text text'
    end

    scenario 'with valid url' do
      fill_in 'Link name', with: 'My Github'
      fill_in 'Url', with: github_url

      click_on 'Add link'

      within all('.nested-fields').last do
        fill_in 'Link name', with: 'My school'
        fill_in 'Url', with: school_url
      end

      click_on 'Send answer'

      within('.answer-links') do
        expect(page).to have_link 'My Github', href: github_url
        expect(page).to have_link 'My school', href: school_url
      end
    end

    scenario 'with invalid url' do
      fill_in 'Link name', with: 'My Github'
      fill_in 'Url', with: 'Github url'

      click_on 'Send answer'

      expect(page).to have_content 'Links url is invalid'
    end
  end

  describe  'User adds links when edits his answer', js: true do
    given!(:answer) { question.answers.first }
    given(:user) { answer.author }
    given!(:google_urls) { create_list(:link_for_question, 2) }

    background do
      login(user)
      visit question_path(question)

      within("#answer-#{answer.id}") do
        click_on 'Edit'
        click_on 'Add link'
      end
    end

    scenario 'with valid url' do
      within("#answer-#{answer.id}") do
        fill_in 'Link name', with: google_urls[0].name
        fill_in 'Url', with: google_urls[0].url

        click_on 'Add link'

        within all('.nested-fields').last do
          fill_in 'Link name', with: google_urls[1].name
          fill_in 'Url', with: google_urls[1].url
        end


        click_on 'Save'

        within('.answer-links') do
          expect(page).to have_link google_urls[0].name, href: google_urls[0].url
          expect(page).to have_link google_urls[1].name, href: google_urls[1].url
        end
      end
    end

    scenario 'with invalid url' do
      within("#answer-#{answer.id}") do
        fill_in 'Link name', with: 'My Github'
        fill_in 'Url', with: 'Github url'

        click_on 'Save'
      end

      expect(page).to have_content 'Links url is invalid'
    end
  end
end


