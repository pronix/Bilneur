User.class_eval do

  attr_accessor   :registration_as_seller
  attr_accessible :registration_as_seller, :firstname, :lastname, :photo, :phone

  # FIXIT: for_review, becouse for review need this resoluton
  has_attached_file :photo,
  :styles => { :medium => ["300x300", :png], :thumb => ["150x150>", :png], :mini => ["25x25#", :png],
               :for_review => ["82x83", :png]},
  :default_style => :thumb,
  :default_url => "/images/missing/photo/missing_:style.png",
  :url => "/assets/photo/:id/:style/:basename.:extension",
  :path => ":rails_root/public/assets/photo/:id/:style/:basename.:extension"



  # associations
  #
  has_many :products, :foreign_key => :owner_id
  has_many :quotes,   :class_name => "Variant", :foreign_key => :seller_id,
           :conditions => [ "variants.is_master = #{connection.quoted_false}" ]
  has_many :shipping_methods, :foreign_key => :seller_id
  has_many :sales, :class_name => "Order", :foreign_key => :seller_id, :conditions => { :virtual => false}
  has_many :orders,  :conditions => { :virtual => false}

  has_many :virtual_sales, :class_name => "VirtualOrder", :foreign_key => :seller_id
  has_many :virtual_orders, :class_name => "VirtualOrder", :foreign_key => :user_id

  # scopes
  #

  # Return a all user who has a saller role
  scope :sellers, Role.find_by_name('seller').users
  # FIXME need to know logic of how select top sellers.
  # FIXME why don't use selers.limit(1) for Array
  scope :sellers_top, Role.find_by_name('seller').users.order('created_at ASC')
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

  def set_seller_role!
    roles << Role.find_or_create_by_name("seller")
  end

  def has_role?(role)
    # If user has one or more this role, return true
    true if roles.map { |x| x.name }.include?(role)
  end

  # instance methods
  #
  def is_admin?
    has_role?("admin")
  end

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
