class GroupSale < ActiveRecord::Base

  # associations
  #
  belongs_to :seller, :class_name => "User"
  belongs_to :variant
  belongs_to :product


  # scopes
  #


  # validates
  #
  validates :name, :seller, :variant, :count, :retail_price, :price, :presence => true
  validates :start_selling, :stop_selling, :presence => true


  # callbacks
  #
  before_validation :fill_data, :on => :create

  # instance methods
  #

  def fill_data
    self.product_id = self.variant.product_id
  end

  def discount_in_amount
    retail_price.to_f - price.to_f
  end

  def discount_in_percentage
    100 - ((price.to_f * 100) / retail_price.to_f).to_i
  end

  # class methods
  #
  class << self


  end # end class << self

end
