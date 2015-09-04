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

  scenario 'displays an average rating for all reviews' do
    leave_review('So so', '3')
    click_link 'Sign out'
    userina = build(:userina)
    sign_up(userina)
    leave_review('Great', '5')
    expect(page).to have_content('Average rating: ★★★★☆')
  end

  #in the tutorial, these tests are unit tests on the ReviewsHelper - maybe should be like this instead?
  scenario 'displays N/A if no ratings' do
    visit '/restaurants'
    expect(page).to have_content('Average rating: N/A')
  end

  scenario 'displays an average rating of 3 stars' do
    leave_review('So so', '3')
    expect(page).to have_content('Average rating: ★★★☆☆')
  end

  scenario 'displays an average rating of 5 stars' do
    leave_review('Great', '5')
    expect(page).to have_content('Average rating: ★★★★★')
  end

  scenario 'displays an average rating for a decimal average' do
    leave_review('So so', '3')
    click_link 'Sign out'
    userina = build(:userina)
    sign_up(userina)
    leave_review('Great', '4')
    expect(page).to have_content('Average rating: ★★★★☆')
  end
end

