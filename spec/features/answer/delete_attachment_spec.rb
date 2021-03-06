require 'rails_helper'

feature 'User can delete answer attachments', %q{
  As an authenticated user
  I'd like to be able to delete attachments of my answer
  And no one except me can delete my attachments
} do

  given(:user) {create(:user)}
  given(:another_user) {create(:user)}
  given(:question) {create(:question, user: user)}
  given!(:another_user_question) {create(:question, user: another_user)}

  describe 'Authenticated user' do
    scenario 'is trying to delete their attachment', js: true do
      sign_in(user)
      visit question_path(question)

      fill_in 'Body', with: 'Test answer'
      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb"]
      click_on 'Answer'

      expect(page).to have_content 'rails_helper.rb'
    end

    scenario "is trying to delete someone else's attachment", js: true do
      sign_in(another_user)
      visit question_path(another_user_question)
      fill_in 'Body', with: 'Test answer'
      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb"]
      click_on 'Logout'
      sign_in(user)
      visit question_path(another_user_question)

      expect(page).to_not have_link 'Delete file'
    end
  end

  scenario "Unauthenticated user is trying to delete attachment", js: true do
    visit question_path(question)

    expect(page).to_not have_link 'Delete file'
  end
end
