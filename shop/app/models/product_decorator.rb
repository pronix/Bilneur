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

  # Return a brief description of product
  # Default max size of description is 120 characters
  # TODO: is bad. Need return first 120 characters with whole word. It's better
  def brief_description
    return description if description.size <= 120
    description.first(120) + ' ...'
  end

  # class methods
  #
  class << self

  end

end
