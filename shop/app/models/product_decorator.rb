Product.class_eval do

  # associations
  #
  belongs_to :owner, :class_name => "User" # seller who added product

  # scopes
  #

  # validates
  #
  validates :ean, :presence => true, :uniqueness => true
  validates :owner, :presence => true

  # callbacks
  #
  after_validation  :hack_after_validate

  # instance methods
  #

  def hack_after_validate #:nodoc:
    errors[:owner].uniq!
    errors[:ean].uniq!
  end


  # class methods
  #
  class << self

  end

end
