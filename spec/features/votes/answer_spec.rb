require 'rails_helper'

feature 'User can vote for a answer', %q{
  In order to rate favorite answer
  user as an authenticated user can vote
} do
  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  describe 'Authenticated user (not author)', js: true do
    before { sign_in(another_user) }
    before { visit question_path(question) }

    scenario 'can vote up' do
      within ".Answer-#{answer.id}" do
        click_on 'up'
        expect(page).to have_content '1'
      end
    end

    scenario 'can vote down' do
      within ".Answer-#{answer.id}" do
        click_on 'down'
        expect(page).to have_content '-1'
      end
    end

    scenario 'can vote only once' do
      within ".Answer-#{answer.id}" do
        click_on 'up'
        expect(page).to have_content '1'
        expect(page).to_not have_content 'up'
        expect(page).to_not have_content 'down'
      end
    end

    scenario 'can re-vote' do
      within ".Answer-#{answer.id}" do
        click_on 'up'
        expect(page).to have_link 'cancel your vote'

        click_on 'cancel your vote'
        expect(page).to_not have_link 'cancel your vote'
      end
    end

    scenario 'can re-vote' do
      within ".Question-#{question.id}" do
        click_on 'up'
        expect(page).to have_link 'cancel your vote'

        click_on 'cancel your vote'
        expect(page).to_not have_link 'cancel your vote'
      end
    end
  end

  scenario "Author cannot vote for their answer" do
    sign_in(user)
    visit question_path(question)

    within "#answer-#{answer.id}" do
      expect(page).to_not have_css '.voting'
    end
  end
end
