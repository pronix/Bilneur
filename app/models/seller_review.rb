class SellerReview < ActiveRecord::Base
  belongs_to :order
  belongs_to :seller, :class_name => "User"
  belongs_to :buyer, :class_name => "User"

  validates_presence_of :rating, :review
  validates_numericality_of :rating, :only_integer => true

  before_validation :prepare_rating

  def prepare_rating
    self.rating = (rating.to_s.match(/(\d+)/) && $1).to_i
  end

  class << self
    def build(_order, _buyer, _seller, params = { })
      new((params||{ }).merge({ :order => _order, :buyer => _buyer, :seller => _seller }))
    end
  end

end
