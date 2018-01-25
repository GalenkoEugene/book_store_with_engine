class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    if user.persisted?
      can :read, [Book, Image, Author, Category]
      can :read, Review, status: true
      can :create, Review
      can :manage, User, id: user.id
    else
      can :read, Review, status: true
      can :read, [Book, Image, Author]
    end
  end
end
