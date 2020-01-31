require 'rails_helper'

feature 'User can unsubscribe to the question', %q{
  In order to remove notifications to new answers
  As an authenticated user
  I'd like to be able to unsubscribe to the question
} do

  given(:user) {create(:user)}
  given(:question) { create(:question, user: user) }

  scenario 'Unauthenticated user' do
    visit question_path(question)

    expect(page).to_not have_link('Unsubscribe')
  end

  scenario 'Authenticated user tries to unsubscribe twice' do
    sign_in(user)
    question.unsubscribe(user)

    visit question_path(question)
    expect(page).to_not have_link('Unsubscribe')
  end

end 
