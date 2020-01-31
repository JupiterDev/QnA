require 'rails_helper'

feature 'User can subscribe to the question', %q{
  In order to receive notifications to new answers
  As an authenticated user
  I'd like to be able to subscribe to the question
} do

  given(:user) {create(:user)}
  given(:question) { create(:question, user: user) }

  scenario 'Unauthenticated user' do
    visit question_path(question)

    expect(page).to_not have_link('Subscribe')
  end

  scenario 'Authenticated user tries to subscribe twice' do
    sign_in(user)
    question.subscribe(user)

    visit question_path(question)
    expect(page).to_not have_link('Subscribe')
  end

end 
