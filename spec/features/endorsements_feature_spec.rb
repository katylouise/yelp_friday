require 'rails_helper'

feature 'endorsing reviews' do
  before do
    user = create(:user)
    userina = create(:userina)
    restaurant = user.restaurants.create(name: 'The Ivy')
    restaurant.build_review({rating: 3, thoughts: "OK"}, user).save
  end

  scenario 'a user can endorse a review, which updates the review endorsement count' do
    visit '/restaurants'
    click_link 'Endorse Review'
    expect(page).to have_content('1 endorsement')
  end
end