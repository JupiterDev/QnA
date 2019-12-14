require 'rails_helper'

feature 'User can create answer to the question', %q{
  In order to help a community solve the problems
  As an authenticated user
  Being on the question page
  I'd like to be able to answer the questions
} do

  given(:user) {create(:user)}
  given(:question) {create(:question, user: user)}

  describe 'Authenticated user', js: true do

    scenario 'create an answer' do
      sign_in(user)
      visit question_path(question)
      fill_in 'Body', with: 'text text'
      click_on 'Answer'
      expect(page).to have_content 'text text'
    end

    scenario 'create an answer with errors' do
      sign_in(user)
      visit question_path(question)
      click_on 'Answer'
      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'Unauthenticated user tries to answer the question', js: true do
    visit question_path(question)
    expect(page).to_not have_content 'Answer'
  end
end
