require 'rails_helper'

feature 'User can delete answer', %q{
  As an authenticated user
  I'd like to be able to delete my answer
  And no one except me can delete my answer
} do

  given(:user) {create(:user)}
  given!(:question) {create(:question, user: user)}
  given!(:answer) {create(:answer, question: question, user: user)}

  given(:another_user) {create(:user)}
  given!(:another_user_question) {create(:question, user: another_user)}
  given!(:another_user_answer) {create(:answer, question: another_user_question, user: another_user)}
  
  describe 'Authenticated user', js: true do
    background { sign_in(user) }

    scenario 'trying to delete their answer' do
      visit question_path(question)
      click_on 'Delete answer'
      expect(page).to_not have_content answer.body
    end

    scenario "trying to delete someone else's answer" do
      visit question_path(another_user_question)

      expect(page).to_not have_link 'Delete answer'
    end
  end

  describe 'Unauthenticated user', js: true do
    scenario "is trying to delete someone answer" do
      visit question_path(question)
      # save_and_open_page
      expect(page).to_not have_link 'Delete answer'
    end
  end
end
