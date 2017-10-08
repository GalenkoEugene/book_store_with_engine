class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    if user.persisted?
      can :read, [Book, Image, Author, Category, OrderStatus, Delivery, Coupon]
      can :read, Review, status: true
      can :create, Review
      can %i[read create update], [Order, Address, CreditCard], user_id: user.id
      can :manage, OrderItem
      can :manage, User, id: user.id
    else
      can :read, Review, status: true
      can :read, [Book, Image, Author]
      can %i[create read update], Order
      can :manage, OrderItem
    end
  end
end
