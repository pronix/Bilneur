Product.class_eval do

  # associations
  #
  belongs_to :owner, :class_name => "User" # seller who added product

  # scopes
  #

  # validates
  #
  validates :ean, :presence => true, :uniqueness => true

  # callbacks
  #

  # instance methods
  #



  # class methods
  #
  class << self

  end

end
