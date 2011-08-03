Variant.class_eval do

   CONDITION = %w(new used)

  # associations
  #
  belongs_to :seller, :class_name => "User"

  # scopes
  #

  # validates
  #
  validates :condition, :presence => true, :inclusion => { :in => CONDITION }
  validates :count_on_hand, :numericality => { :greater_than => 0 }
  validates :price, :numericality => { :greater_than => 0 }

  # callbacks
  #
  before_validation :set_seller, :on => :create

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


  # class methods
  #
  class << self

  end

end
