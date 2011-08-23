class SellerAbility
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    if user.has_role?("seller") || user.has_role?("admin")
      can :access, :quote
      can :access, :seller
      can :access, :about
    else
      cannot :access, :quote
      cannot :access, :seller
      cannot :access, :about
    end

    # if !user.has_role?('user') and Spree::Reviews::Config[:require_login]
    #   cannot [:new,:create], :review
    # else
    #   can [:new,:create], :review
    # end


    can [:edit, :update, :destroy], Property do |resource|
      resource.owner == user
    end

    can [:edit, :update, :destroy], Product do |resource|
      resource.owner == user
    end

  end
end
