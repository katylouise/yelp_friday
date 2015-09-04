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
end
