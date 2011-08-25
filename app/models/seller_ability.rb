class SellerAbility
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    if user.has_role?("seller") || user.has_role?("admin")
      can :access, :quote
      can :access, :seller
    else
      cannot :access, :quote
      cannot :access, :seller
    end

    # Only auth user has create review or when admin set setting
    if user.roles.present? || !Spree::Reviews::Config[:require_login]
      can [:new, :create], Review
    else
      cannot [:new, :create], Review
    end

    can [:edit, :update, :destroy], Property do |resource|
      resource.owner == user
    end

    can [:edit, :update, :destroy], Product do |resource|
      resource.owner == user
    end

  end
end
