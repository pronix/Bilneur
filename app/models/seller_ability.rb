class SellerAbility
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    if user.has_role?("seller") || user.has_role?("admin")
      can :access, :quote
    else
      cannot :access, :quote
    end

    can [:edit, :update, :destroy], Property do |resource|
      resource.owner == user
    end

    can [:edit, :update, :destroy], Product do |resource|
      resource.owner == user
    end


  end
end
