require 'rails_helper'

feature 'User can create a comment for the question or answer', %q{
    In order to add info
    As an authenticated user
    I'd like to be able to comment the question or answer
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'Authenticated user creates comment for question', js: true do

    sign_in user
    visit question_path(question)

    within '.question' do
      fill_in 'Your comment', with: 'Test comment'
      click_on 'Add comment'

      expect(page).to have_content 'Test comment'
    end
  end

  scenario 'Unauthenticated user tries to create comment for question', js: true do
    visit question_path(question)

    within '.question' do
      fill_in 'Your comment', with: 'Test comment'
      click_on 'Add comment'

      expect(page).to_not have_content 'Test comment'
    end
  end

  describe "Multiple sessions_appears on another user's page ", js: true do
    scenario "question's comment" do
      Capybara.using_session('user') do
        sign_in user
        visit question_path(question)
        within '.question' do
          fill_in 'Your comment', with: 'Test comment'
          click_on 'Add comment'

          expect(page).to have_content 'Test comment'
        end
      end

      Capybara.using_session('guest') do
        visit question_path(question)
        within '.question' do
          expect(page).to have_content 'Test comment'
        end
      end
    end

    scenario "answer's comment" do
      Capybara.using_session('user') do
        sign_in user
        visit question_path(question)
        within '.answers' do
          fill_in 'Your comment', with: 'Test comment'
          click_on 'Add comment'
        end
      end

      Capybara.using_session('guest') do
        visit question_path(question)
        within '.answers' do
          expect(page).to have_content 'Test comment'
        end
      end
    end
  end
end
