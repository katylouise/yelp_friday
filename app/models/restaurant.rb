class Restaurant < ActiveRecord::Base

  has_many :reviews, dependent: :destroy

  belongs_to :user

  validates :name, length: {minimum: 3}, uniqueness: true

  has_attached_file :image, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/restaurant-md.png"
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/

  def build_review(review, user)
    self.reviews.new(thoughts: review[:thoughts], rating: review[:rating], user_id: user.id)
  end

  def average_rating
    return 'N/A' if self.reviews.none?
    self.reviews.average(:rating).round
  end

  # def star_rating(rating)
  #   return rating unless rating.is_a?(Integer)
  #   return black_stars + white_stars
  # end

  # def black_stars
  #   black_stars = ''
  #   average_rating.to_i.times{ black_stars += "★" }
  #   return black_stars
  # end

  # def white_stars
  #   white_stars = ''
  #   (5 - self.average_rating.to_i).times{ white_stars += "☆" }
  #   return white_stars
  # end
end
