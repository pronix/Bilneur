Review.class_eval do
  before_validation :name_as_register_user

  # Return last 3 review
  scope :last_reviews, lambda{ |count| approved.order("created_at DESC").first(count) }

  # Return user name, if review was create as anonymous ve user name from Review
  # Else using firstname and lastname from User model with some fix
  def simple_username
    return user.firstname + ' ' + user.lastname.first + '.' if !user.nil?
    name
  end

  def name_as_register_user
    # Dirty but I don't now how remove validation from gem
    # If review write a register user, he should not write yours name
    self.name = 'TEST' if self.user
  end

end
