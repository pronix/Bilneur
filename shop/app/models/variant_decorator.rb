Variant.class_eval do

   CONDITION = %w(new used another)

  # associations
  #
  belongs_to :seller, :class_name => "User"
  belongs_to :owner, :class_name => "User" # seller who added quote, not virtual seller
  # scopes
  #
  CONDITION.each { |v| scope :"condition_#{v}", where(:condition => v)}
  scope :condition, lambda{ |*args|
    where(:condition => (args.first =~ /new|used|another/ ? args.first : "new"))
  }

  scope :on_hand, where("variants.count_on_hand > 0")
  scope :without_master, where(:is_master => false)
  scope :by_price, order("variants.price ASC")
  scope :best_price, lambda{ |*args|
       args.first ? condition(*args).by_price.limit(1) : by_price.limit(1)
    }

  scope :best_variant, active.on_hand.order("variants.price ASC").limit(1)

  # validates
  #
  validates :condition, :inclusion => { :in => CONDITION },   :unless => lambda{|t| t.is_master? }
  validates :another_condition, :presence => true, :if => lambda{ |t| t.condition == "another"}

  validates :count_on_hand, :numericality => { :greater_than_or_equal_to => 0 }, :unless => lambda{|t| t.is_master? }
  validates :price, :numericality => { :greater_than => 0 },                     :unless => lambda{|t| t.is_master? }
  validates :seller, :owner, :presence => true,                                          :unless => lambda{|t| t.is_master? }


  # callbacks
  #
  before_validation :set_seller, :on => :create
  after_save :recalculate_count_on_hand, :unless => lambda{|t| t.is_master? }
  after_validation  :hack_after_validate



  # instance methods
  #
  delegate_belongs_to :product, :ean

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



  # class methods
  #
  class << self

  end

end
