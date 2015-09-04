require 'rails_helper'

feature 'reviewing' do
  before(:each) do
    user = build(:user)

    sign_up(user)
    click_link 'Add a restaurant'
    fill_in 'Name', with: 'KFC'
    click_button 'Create Restaurant'
  end

  scenario 'allows users to leave a review using a form' do
    visit '/restaurants'
    click_link 'Review KFC'
    fill_in "Thoughts", with: "so so"
    select '3', from: 'Rating'
    click_button 'Leave Review'
    expect(current_path).to eq '/restaurants'
    expect(page).to have_content('so so')
  end

  scenario 'only allows user who created review to delete it' do
    visit '/restaurants'
    click_link 'Review KFC'
    fill_in "Thoughts", with: "so so"
    select '3', from: 'Rating'
    click_button 'Leave Review'
    click_link 'Delete review'
    expect(page).not_to have_content('so so')
  end

  scenario 'does not allow user to delete review if they did not create it' do
    visit '/restaurants'
    click_link 'Review KFC'
    fill_in "Thoughts", with: "so so"
    select '3', from: 'Rating'
    click_button 'Leave Review'
    click_link 'Sign out'
    userina = build(:userina)
    sign_up(userina)
    expect(page).not_to have_link('Delete review')
  end

  scenario 'deletes review when you delete a restaurant' do
    visit '/restaurants'
    click_link 'Review KFC'
    fill_in 'Thoughts', with: 'So-so'
    select '3', from: 'Rating'
    click_button 'Leave Review'
    click_link 'Delete KFC'
    expect(page).not_to have_content 'So-so'
  end
end

