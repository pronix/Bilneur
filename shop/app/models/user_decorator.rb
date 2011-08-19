User.class_eval do

  attr_accessor   :registration_as_seller
  attr_accessible :registration_as_seller, :firstname, :lastname, :photo, :phone, :reviews_count, :avg_rating

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
  has_many :seller_stores, :foreign_key => :seller_id
  has_many :quotes,   :class_name => "Variant", :foreign_key => :seller_id,
                      :conditions => [ "variants.is_master = #{connection.quoted_false}" ]
  has_many :shipping_methods, :foreign_key => :seller_id
  has_and_belongs_to_many :sales,         :join_table => "orders_users", :class_name => "Order",
                                          :conditions => { :"orders.virtual" => false}
  has_and_belongs_to_many :virtual_sales, :join_table => "orders_users", :class_name => "Order",
                                          :conditions => { :"orders.virtual" => true}

  has_many :orders,  :conditions => { :virtual => false}
  has_many :virtual_orders, :class_name => "VirtualOrder", :foreign_key => :user_id

  has_many :seller_payment_methods

  has_many :sent,  :order => "created_at", :class_name => "Message", :foreign_key => "sender_id"
  has_many :inbox, :order => "created_at", :class_name => "Message", :foreign_key => "recipient_id"

  # Associate with SecretQuestion
  has_one :secret_question

  # Return all seller reviews by user
  has_many :seller_reviews, :foreign_key => 'buyer_id'
  has_many :buyer_reviews, :foreign_key => 'seller_id', :class_name => "SellerReview"

  # scopes
  #

  # Return a all user who has a saller role
  # scope :sellers, Role.find_by_name('seller').users
  # FIXME need to know logic of how select top sellers.
  # FIXME why don't use selers.limit(1) for Array
  # FIXME Add rescue becouse on the migrate goes to error
  scope :sellers_top, Role.find_by_name('seller').users.order('avg_rating DESC') rescue []
  # scope :sellers_top, find_by_sql([ "SELECT * FROM users WHERE id in(SELECT user_id FROM roles_users WHERE role_id = ?)",
  #                             Role.find_by_name('seller').id])
  # validates
  #

  # callbacks
  #
  after_create :set_roles

  # Recalculate rating for seller, from SellerReview
  def recalculate_rating
    reviews_count = buyer_reviews.reload.count
    if reviews_count > 0
      self.update_attributes(:reviews_count => reviews_count, :avg_rating => buyer_reviews.sum(:rating).to_f / reviews_count )
    else
      update_attribute(:avg_rating, 0)
    end
  end

  def has_seller_review?
    true if !seller_reviews.blank?
  end

  def has_buyer_review?
    true if !buyer_reviews.blank?
  end

  # This is for secret question
  def check_valid_user_with_regular_question(params)
    return false if !check_question_answer(params)
    # Check if user question is match
    return false if secret_question.secret_question_variant_id != params[:secret_question][:secret_question_variant_id].to_i
    true
  end

  def check_valid_user_with_own_question(params)
    return false if !check_question_answer(params)
    # Check if user have secret question
    return false if !SecretQuestionVariant.find_by_variant(params[:own_question])
    true
  end

  def check_question_answer(params)
    # Check if user have secret question
    return false if !has_secret?
    # Check if user have answer with put anwer
    return false if secret_question.answer != params[:secret_question][:answer]
    true
  end

  def has_secret?
    true unless secret_question.nil?
  end

  # Setting the roles on default
  #
  def set_roles
    roles << Role.find_or_create_by_name("user")
    as_seller! if @registration_as_seller.to_i == 1
  end

  def set_seller_role!
    as_seller!
  end

  # instance methods
  #

  def as_seller!
    roles << Role.find_or_create_by_name("seller") unless has_role?("seller")
    create_virtual_methods!
  end

  # Default create virtual shipping
  #
  def create_virtual_methods!

    unless shipping_methods.to_bilneur.first
      shipping_method = ShippingMethod.new(:calculator => Calculator::FlatRate.new,
                                           :name => "Ship to Bilneur",
                                           :seller_id => self.id,
                                           :virtual => true,
                                           :method_kind => ShippingMethod::METHOD_KIND_TO_BILNEUR)
      shipping_method.save(:validate => false)
    end

    unless shipping_methods.with_seller.first
      shipping_method = ShippingMethod.new(:calculator => Calculator::FlatRate.new,
                                           :name => "Store with seller",
                                           :seller_id => self.id,
                                           :virtual => true,
                                           :method_kind => ShippingMethod::METHOD_KIND_WITH_SELLER)
      shipping_method.save(:validate => false)
    end

  end

  def messages
    Message.messages_for_user(self)
  end

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

  def available_shipping_methods?
    shipping_methods.to_address.present?
  end

  # class methods
  #
  class << self

  end

end
