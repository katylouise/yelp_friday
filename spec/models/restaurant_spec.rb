require 'rails_helper'
require 'spec_helper'

describe Restaurant, type: :model do

  context 'relationship with reviews' do
    it { is_expected.to have_many :reviews }
  end

  context 'relationship with user' do
    it { is_expected.to belong_to :user }
  end

  context 'validation' do
    it 'is not valid with a name of less than three characters' do
      restaurant = Restaurant.new(name: "kf")
      expect(restaurant).to have(1).error_on(:name)
      expect(restaurant).not_to be_valid
    end

    it 'is not valid unless it has a unique name' do
        Restaurant.create(name: "Moe's Tavern")
        restaurant = Restaurant.new(name: "Moe's Tavern")
        expect(restaurant).to have(1).error_on(:name)
    end
  end

  describe '#average_rating' do
    context 'no reviews' do
      it 'returns "N/A" when there are no reviews' do
        restaurant = Restaurant.create(name: 'The Ivy')
        expect(restaurant.average_rating).to eq 'N/A'
      end
    end

    context '1 review' do
      it 'returns that rating' do
        restaurant = Restaurant.create(name: 'The Ivy')
        restaurant.reviews.create(rating: 4)
        expect(restaurant.average_rating).to eq 4
      end
    end

    context 'multiple reviews' do
      it 'returns the average' do
        user = create(:user)
        userina = create(:userina)
        restaurant = user.restaurants.create(name: 'The Ivy')
        restaurant.build_review({rating: 3}, user).save
        restaurant.build_review({rating: 5}, userina).save
        expect(restaurant.average_rating).to eq 4
      end
    end
  end

end
