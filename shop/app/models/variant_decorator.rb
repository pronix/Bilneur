Variant.class_eval do

   CONDITION = %w(new used)

  # associations
  #
  belongs_to :seller, :class_name => "User"

  # scopes
  #


  # validates
  #
  validates :condition, :presence => true, :inclusion => { :in => CONDITION },   :unless => lambda{|t| t.is_master? }
  validates :count_on_hand, :numericality => { :greater_than_or_equal_to => 0 }, :unless => lambda{|t| t.is_master? }
  validates :price, :numericality => { :greater_than => 0 },                     :unless => lambda{|t| t.is_master? }
  validates :seller, :presence => true,                                          :unless => lambda{|t| t.is_master? }

  # callbacks
  #
  before_validation :set_seller, :on => :create
  after_save :recalculate_count_on_hand, :unless => lambda{|t| t.is_master? }

  # Set current user as owner quote
  #
  def set_seller(user = User.current)
    self.seller = user
  end


  # instance methods
  #
  delegate_belongs_to :product, :ean

  def mark_deletion!(time_deletion = Time.now)
    self.deleted_at = time_deletion
    save
  end

  [:description, :name].each do |m|

    define_method "#{m}" do
      read_attribute(m) || product.send(m)
    end

    define_method "#{m}=" do |value|
      write_attribute("#{m}", value)
    end

  end

  def recalculate_count_on_hand
    product.send(:recalculate_count_on_hand)
    product.save
  end

  # class methods
  #
  class << self

  end

end
