Product.class_eval do

  # associations
  #
  belongs_to :owner, :class_name => "User" # seller who added product

  has_one :best_variant,
          :class_name => 'Variant',
          :conditions => [
                          "variants.is_master = #{connection.quoted_false}
                           AND variants.deleted_at IS NULL
                           AND variants.count_on_hand > 0 "],
          :order => "variants.price ASC"


  # scopes
  #
  # scope :on_hand, where("COALESCE(( SELECT sum(variants.count_on_hand)
  #                   FROM variants
  #                   WHERE (variants.is_master = #{connection.quoted_false}
  #                          AND variants.product_id = products.id
  #                          AND variants.deleted_at is null) ),0) > 0")






  # validates
  #
  validates :ean, :presence => true, :uniqueness => true
  validates :owner, :presence => true

  # callbacks
  #
  before_validation :set_default_data, :on => :create
  before_validation :set_owner, :on => :create
  after_validation  :hack_after_validate

  # instance methods
  #
  def set_owner(user_owner = User.current)
    self.owner ||= user_owner
  end

  def set_default_data
    self.price ||= 1
    self.available_on ||= Time.now
  end

  def hack_after_validate #:nodoc:
    errors[:owner].uniq! if errors.has_key?(:owner)
    errors[:ean].uniq! if errors.has_key?(:ean)
  end

  # class methods
  #
  class << self

  end

end
