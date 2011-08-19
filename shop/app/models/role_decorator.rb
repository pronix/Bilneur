Role.class_eval do
  class << self
    def user
      find_or_create_by_name("user")
    end
    def seller
      find_or_create_by_name("seller")
    end

  end
end
