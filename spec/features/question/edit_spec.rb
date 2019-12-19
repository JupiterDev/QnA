require 'rails_helper'

feature 'User can edit his question', %q{
  In order to correct mistakes
  As an author of question
  I'd like ot be able to edit my question
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:another_user) { create(:user) }
  given!(:another_question) { create(:question, user: another_user) }

  scenario 'Unauthenticated can not edit question' do
    visit question_path(question)
    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user' do
    scenario 'edits his question', js: true do
      sign_in user
      visit question_path(question)
      within '.question' do
        click_on 'Edit question'
        fill_in 'Question title', with: 'question title'
        fill_in 'Question body', with: 'question body'

        click_on 'Save'
        expect(page).to_not have_content question.title
        expect(page).to_not have_content question.body
        expect(page).to have_content 'question title'
        expect(page).to have_content 'question body'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edits his question with errors', js: true do
      sign_in user
      visit question_path(question)

      within '.question' do
        click_on 'Edit'
        fill_in 'Question title', with: ''
        fill_in 'Question body', with: ''
        click_on 'Save'

        expect(page).to have_content question.body
      end
      expect(page).to have_content "Body can't be blank"

    end

    scenario "tries to edit other user's question" do
      visit question_path(another_question)

      expect(page).to_not have_button 'Edit'
    end
  end

end