require 'rails_helper'

feature 'User can view a list of questions', %q{
  In order to find the right question
  I'd like to be able to view a list of questions
} do

  given(:user) {create(:user)}
  given!(:questions) {create_list(:question, 10, user: user)}

  scenario 'Authenticated user tries to view a list of questions' do
    sign_in(user)
    visit questions_path

    questions.each do |question|
      expect(page).to have_content question.title
      expect(page).to have_content question.body
    end

  end

  scenario 'Anauthenticated user tries to view a list of questions'
end
