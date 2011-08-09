Review.class_eval do
  before_validation :name_as_register_user


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
