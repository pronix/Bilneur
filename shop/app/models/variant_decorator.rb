Variant.class_eval do

  # associations
  #
  belongs_to :seller, :class_name => "User"
  belongs_to :owner, :class_name => "User" # seller who added quote, not virtual seller
  has_and_belongs_to_many :favorite_users, :join_table => "favorite_variants", :class_name => "User", :uniq => true



  # scopes
  #
  Variant::CONDITION.each { |v| scope :"condition_#{v}", where(:condition => v)}
  Variant::WAREHOUSE.each { |v| scope :"warehouse_#{v}", where(:warehouse => v)}

  scope :active, where("variants.deleted_at is null AND variants.active = #{connection.quoted_true}")
  scope :inactive, where("variants.deleted_at is null AND variants.active = #{connection.quoted_false}")

  scope :condition, lambda{ |*args|
    where(:condition => (args.first =~ /new|used|another/ ? args.first : "new"))
  }


  scope :on_hand, where("variants.count_on_hand > 0")
  scope :without_master, where(:is_master => false)
  scope :by_price, order("variants.price ASC")
  scope :best_price, lambda{ |*args|
       args.first ? condition(*args).by_price.limit(1) : by_price.limit(1)
    }

  scope :best_variant, lambda{ |*args|
    options = args.first || { }
    if options[:seller_id]
      active.on_hand.where(:seller_id => options[:seller_id]).order("variants.price ASC, variants.count_on_hand DESC").limit(1)
    else
      active.on_hand.order("variants.price ASC, variants.count_on_hand DESC").limit(1)
    end

  }

  scope :virtual, where(:virtual => true)
  scope :realy,   where(:virtual => false)

  # validates
  #
  validates :condition, :inclusion => { :in => Variant::CONDITION },   :unless => lambda{|t| t.is_master? }
  validates :another_condition, :presence => true, :if => lambda{ |t| t.condition == "another"}

  validates :count_on_hand, :numericality => { :greater_than_or_equal_to => 0 }, :unless => lambda{|t| t.is_master? }
  validates :price, :numericality => { :greater_than => 0 },                     :unless => lambda{|t| t.is_master? }
  validates :seller, :owner, :presence => true,                                          :unless => lambda{|t| t.is_master? }
  validates :weight, :numericality => { :greater_than => 0 }, :unless => :is_master?


  # callbacks
  #
  before_validation :set_seller, :on => :create
  # after_save :recalculate_count_on_hand, :unless => lambda{|t| t.is_master? }
  after_validation  :hack_after_validate
  after_create :set_int_condition!,   :unless => lambda{|t| t.is_master? }


  # instance methods
  #
  delegate_belongs_to :product, :ean


  def is_favorite?(_user = nil)
    _user.present? && favorite_users.find_by_id(_user.id).present?
  end

  # Shipping cost for variant
  # only realy shipping methods
  #
  #
  def shipping
    seller.shipping_methods.realy[0..0].map do |item|
      {
        :zone => item.zone.try(:name),
        :cost => (item.calculator.respond_to?(:compute_for_one_variant) ? item.calculator.compute_for_one_variant(self) : 0)
      }
    end
  end

  # Sample the first shipping
  #
  def primary_shipping
    shipping.first.try(:[], :cost)
  end

  # Set current user as seller and owner quote
  #
  def set_seller(user = User.current)
    self.seller ||= user
    self.owner  ||= self.seller
  end

  # Set the quote as virtual
  #
  def virtual!
    update_attribute(:virtual, true)
  end

  def image
    (self.images.blank? ? product.images : images).last
  end

  def hack_after_validate #:nodoc:
    errors[:seller].uniq! if errors.has_key?(:seller)
    errors[:condition].uniq! if errors.has_key?(:condition)
  end


  def mark_deletion!(time_deletion = Time.now)
    self.deleted_at = time_deletion
    save
  end

  [:description, :name].each do |m|

    define_method "#{m}" do
      self_value = read_attribute(m)
      self_value.blank? ? product.send(m) : self_value
    end

    define_method "#{m}=" do |value|
      write_attribute("#{m}", value)
    end

  end

  def recalculate_count_on_hand
    product.send(:recalculate_count_on_hand)
    product.save
  end

  def has_variants? # :nodoc
    false
  end
  def master
    self
  end
  alias :has_stock? :in_stock?

  def move_to_virtual_seller(new_seller, quantity, _warehouse = Variant::WAREHOUSE_MERCHANT)
    new_variant = clone
    new_variant.seller = new_seller
    new_variant.count_on_hand = quantity
    new_variant.virtual = true
    image_clone = lambda {|i| j = i.clone; j.attachment = i.attachment.clone; j}
    new_variant.images = self.images.map {|i| image_clone.call i }
    new_variant.deleted_at = nil
    new_variant.weight = (self.weight||1)
    new_variant.warehouse = _warehouse
    new_variant.save!
    new_variant
  end

  def set_int_condition!
    update_attribute(:condition_int, Variant::CONDITION_MAP[self.condition.to_sym]) if self.condition.present?
  end

  def display_condition
    condition.to_s == "another" ? another_condition : condition
  end
  # class methods
  #
  class << self

    # Find review from product
    def by_product_and_id(product_id, quote_id)
      self.where(:product_id => Product.find_by_permalink(product_id).id).find(quote_id)
    end

  end

end
