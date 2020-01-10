require 'rails_helper'

feature 'User can add links to answer', %q{
  In order to provide additional info to my answer
  As an question's author
  I'd like to be able to add links
} do

  given(:user) {create(:user)}
  given!(:question) {create(:question, user: user)}
  given(:gist_url) {'https://gist.github.com/vkurennov/743f9367caa1039874af5a2244e1b44c'}
  given(:invalid_url) {'abcdef.com'}

  scenario 'User adds links when gives an answer', js: true do
    sign_in(user)

    visit question_path(question)

    fill_in 'Body', with: 'My answer'

    fill_in 'Link name', with: 'My gist'
    fill_in 'Link url', with: gist_url

    click_on 'Add link'

    within all('.nested-fields')[1] do
      fill_in 'Link name', with: 'My another gist'
      fill_in 'Link url', with: gist_url
    end

    click_on 'Answer'

    within '.answers' do
      expect(page).to have_link 'My gist', href: gist_url
      expect(page).to have_link 'My another gist', href: gist_url
    end
  end

  scenario 'User adds invalid link when gives an answer', js: true do
    sign_in(user)

    visit question_path(question)

    fill_in 'Body', with: 'My answer'

    fill_in 'Link name', with: 'My gist'
    fill_in 'Link url', with: invalid_url

    click_on 'Answer'

    expect(page).to have_content 'Links url must be valid'
    expect(page).to_not have_link 'My gist', href: invalid_url

  end

end
