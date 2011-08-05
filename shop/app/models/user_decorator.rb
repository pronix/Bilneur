User.class_eval do

  attr_accessor   :registration_as_seller
  attr_accessible :registration_as_seller


  # associations
  #
  has_many :products, :foreign_key => :owner_id
  has_many :quotes,   :class_name => "Variant", :foreign_key => :seller_id,
           :conditions => [ "variants.is_master = #{connection.quoted_false}" ]
  has_many :shipping_methods, :foreign_key => :seller_id

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

  def full_name
    "#{self.firstname} #{self.lastname}"
  end

  # TODO
  # can automate the verification process
  #
  def verify_process!
    updated_attribute(:verified, true)
  end


  # class methods
  #
  class << self

  end

end
