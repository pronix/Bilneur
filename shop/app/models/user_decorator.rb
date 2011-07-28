User.class_eval do

  attr_accessor   :registration_as_seller
  attr_accessible :registration_as_seller


  # associations
  #

  # scopes
  #

  # validates
  #

  # callbacks
  #
  after_create :set_roles

  # Setting the roles on default
  #
  def set_roles
    roles << Role.find_or_create_by_name("user")
    roles << Role.find_or_create_by_name("seller") if @registration_as_seller.to_i == 1
  end


  # instance methods
  #

  # TODO
  # can automate the verification process
  #
  # Verified seller status
  #
  def verified?
    true
  end


  # class methods
  #
  class << self

  end

end
