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

    can :create_group_sale, Variant do |variant|
      variant.seller == user && variant.count_on_hand > 0
    end

    can :read, GroupSale do |resource|
      user.has_role?("seller") && (resource.present? ? (resource.seller_id == user.id) : true)
    end

    can [:edit, :update, :destroy, :cancel, :complete], GroupSale do |resource|
      user.has_role?("seller") && (resource.seller_id == user.id)
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
