OptionType.class_eval do

  # associations
  #
  belongs_to :owner, :class_name => "User"


  # scopes
  #

  # validates
  #

  # callbacks
  #
  before_validation :set_owner, :on => :create

  def set_owner(user = User.current)
    self.owner = user
  end


  # instance methods
  #

  # class methods
  #
  class << self

  end

end
