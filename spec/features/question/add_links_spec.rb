require 'rails_helper'

feature 'User can add links to question', %q{
  In order to provide additional info to my question
  As an question's author
  I'd like to be able to add links
} do

  describe 'User adds links when asks question', js: true do
    given(:user) { create(:user) }
    given(:github_url) { 'https://github.com/WhatTheAncient' }
    given(:school_url) { 'https://thinknetica.com' }

    background do
      login(user)
      visit new_question_path

      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'
    end

    scenario 'with valid url' do
      fill_in 'Link name', with: 'My Github'
      fill_in 'Url', with: github_url

      click_on 'Add link'

      within all('.nested-fields').last do
        fill_in 'Link name', with: 'My school'
        fill_in 'Url', with: school_url
      end

      click_on 'Ask'

      within('.question-links') do
        expect(page).to have_link 'My Github', href: github_url
        expect(page).to have_link 'My school', href: school_url
      end
    end

    scenario 'with invalid url' do
      fill_in 'Link name', with: 'My Github'
      fill_in 'Url', with: 'Github url'
      click_on 'Ask'


      expect(page).to have_content 'Links url is invalid'
    end
  end

  describe 'Author adds links when edit question', js: true do

    given!(:question) { create(:question) }
    given!(:user) { question.author }
    given!(:google_urls) { create_list(:link_for_question, 2) }

    background do
      login(user)
      visit question_path(question)

      click_on 'Edit question'
      within '.question' do
        click_on 'Add link'
      end
    end

    scenario 'with valid url' do
      within '.question' do
        fill_in 'Link name', with: google_urls[0].name
        fill_in 'Url', with: google_urls[0].url

        click_on 'Add link'

        within all('.nested-fields').last do
          fill_in 'Link name', with: google_urls[1].name
          fill_in 'Url', with: google_urls[1].url
        end
      end

      click_on 'Save'

      within('.question-links') do
        expect(page).to have_link google_urls[0].name, href: google_urls[0].url
        expect(page).to have_link google_urls[1].name, href: google_urls[1].url
      end
    end

    scenario 'with invalid url' do
      within ('.question') do
        fill_in 'Link name', with: 'My Github'
        fill_in 'Url', with: 'Github url'
      end
      click_on 'Save'


      expect(page).to have_content 'Links url is invalid'
    end
  end
end

