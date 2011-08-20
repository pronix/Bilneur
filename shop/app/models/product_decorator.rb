Product.class_eval do



  # associations
  #
  belongs_to :owner, :class_name => "User" # seller who added product

  has_one :worst_varinat,
          :class_name => 'Variant',
          :conditions => [
                          "variants.is_master = #{connection.quoted_false}
                           AND variants.deleted_at IS NULL
                           AND variants.count_on_hand > 0 "],
          :order => "variants.price DESC"


  # scopes
  #
  # scope :on_hand, where("COALESCE(( SELECT sum(variants.count_on_hand)
  #                   FROM variants
  #                   WHERE (variants.is_master = #{connection.quoted_false}
  #                          AND variants.product_id = products.id
  #                          AND variants.deleted_at is null) ),0) > 0")

  scope :latest, lambda{ |*args|
    active.on_hand.includes(:variants).limit(args.first || 20).order("products.created_at DESC")
  }

  # Return a top products, ordering by ASC, higth ratting is first
  scope :tops, active.on_hand.order('avg_rating DESC')

  scope :top_deals, lambda{
    order("( SELECT min(v.price) FROM variants as v
           WHERE ( (v.is_master = #{connection.quoted_false}) AND (v.product_id = products.id) AND (v.deleted_at is null ) AND (v.count_on_hand > 0) )
          ) ASC")
   }


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
  def best_variant(condition = nil)
    if condition
      variants.condition(condition).best_variant.first
    else
      variants.best_variant.first
    end

  end

  def best_price(condition = nil)
    variants.best_price(condition).first.try(:price)
  end

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

  def similar_products(count=3)
    Product.active.on_hand.where("products.id != ?", id).in_taxons(self.taxons).limit(count)
  end

  def last_photo(style='product')
    images.last.attachment.url(style.to_sym) rescue '/images/img/sml_iph.png'
  end

  # Select all FeedbackReview where is reviews from current product
  def recomends_count
    FeedbackReview.count(:conditions => { :review_id => review_ids})
  end

  # class methods
  #
  class << self


  end # end class << self

end
