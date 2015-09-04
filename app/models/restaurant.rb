class Restaurant < ActiveRecord::Base

  has_many :reviews, dependent: :destroy

  belongs_to :user

  validates :name, length: {minimum: 3}, uniqueness: true

  def build_review(review, user)
    self.reviews.new(thoughts: review[:thoughts], rating: review[:rating], user_id: user.id)
  end

  def average_rating
    return 'N/A' if self.reviews.none?
    self.reviews.average(:rating)
  end

  def black_stars
    black_stars = ''
    average_rating.to_i.times{ black_stars += "★" }
    return black_stars
  end

  def white_stars
    white_stars = ''
    (5 - self.average_rating.to_i).times{ white_stars += "☆" }
    return white_stars
  end
end
