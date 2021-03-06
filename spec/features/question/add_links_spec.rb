require 'rails_helper'

feature 'User can add links to question', %q{
  In order to provide additional info to my question
  As an question's author
  I'd like to be able to add links
} do

  given(:user) { create(:user) }
  given(:gist_url) { 'https://gist.github.com/vkurennov/743f9367caa1039874af5a2244e1b44c' }
  given(:invalid_url) {'abcdef.com'}

  scenario 'User adds links when asks question', js: true do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'

    fill_in 'Link name', with: 'My gist'
    fill_in 'Link url', with: gist_url
    
    click_on 'Add link'
    
    within all('.nested-fields')[1] do
      fill_in 'Link name', with: 'My another gist'
      fill_in 'Link url', with: gist_url
    end
    
    click_on 'Ask'

    expect(page).to have_link 'My gist', href: gist_url
    expect(page).to have_link 'My another gist', href: gist_url
  end

  scenario 'User adds invalid link when asks question', js: true do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'

    fill_in 'Link name', with: 'My gist'
    fill_in 'Link url', with: invalid_url
    
    click_on 'Ask'

    expect(page).to_not have_link 'My gist', href: invalid_url
  end

end
