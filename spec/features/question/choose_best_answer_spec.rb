require 'rails_helper'

feature 'User can choose the best answer', %q{
  In order to indicate a solution to the problem
  As an author of question
  I'd like ot be able to mark the right answer
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answers) { create_list(:answer, 5, question: question, user: user) }
  given!(:another_user) { create(:user) }
  given!(:another_question) { create(:question, user: another_user) }

  scenario 'Unauthenticated can not choose the best answer' do
    visit question_path(question)
    expect(page).to_not have_link 'The best'
  end

  describe 'Authenticated user' do

    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'chooses the best answer', js: true do
      first('.best-answer').click
      expect(page).to have_css('.best', count: 1)
    end

    scenario 'chooses another best answer', js: true do
      within "#answer-#{answers.first.id}" do
        click_on 'The best'
      end
      within "#answer-#{answers.second.id}" do
        click_on 'The best'
      end
      expect(page).to have_css('.best', count: 1)
    end

    scenario "make best answer is displayed first in the answer list", js: true do
      best_answer = answers.last
      within("#answer-#{answers.last.id}") { click_on 'The best' }
      first_answer = find('.answers').first(:element)
      within first_answer do
        expect(page).to have_content best_answer.body
      end
    end

  end
end
