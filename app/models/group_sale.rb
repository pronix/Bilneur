class GroupSale < ActiveRecord::Base

  # associations
  #
  belongs_to :seller, :class_name => "User"
  belongs_to :variant
  belongs_to :product


  # scopes
  #
  scope :best, lambda{ |*args|
    options = args.extract_options!
    if options[:condition]
      includes(:variant).where(:variants => { :condition => options[:condition] }).order("group_sales.price DESC").limit(1)
    else
      order("group_sales.price DESC").limit(1)
    end
  }

  # validates
  #
  validates :name, :seller, :variant, :count, :retail_price, :price, :presence => true


  validates_numericality_of :count, :only_integer => true, :greater_than  => 0,
   :less_than_or_equal_to  => lambda{ |t|
    (t.new_record? ? t.variant.on_hand : t.variant.on_hand + (t.changes[:count].try(:first) || t.count).to_i) }

  validates :start_selling, :date => {  :after => Date.today  }, :on => :create
  validates :stop_selling,  :date => {  :after => Date.today, :after  => :start_selling  }, :on => :create


  # callbacks
  #
  before_validation :fill_data, :on => :create
  after_create :lock_quantity
  after_destroy :unlock_quantity

  # instance methods
  #

  # Set product
  #
  def fill_data
    self.product_id = self.variant.try(:product_id)
  end

  def discount_in_amount
    retail_price.to_f - price.to_f
  end

  def discount_in_percentage
    100 - ((price.to_f * 100) / retail_price.to_f).to_i
  end

  # Reserve the number of goods
  #
  def lock_quantity
    variant.on_hand = variant.on_hand - self.count
    variant.save
  end

  # Return the reserved item if you cancel or delete
  #
  def unlock_quantity
    variant.on_hand = variant.on_hand + self.count
    variant.save
  end


  # class methods
  #
  class << self


  end # end class << self

end
