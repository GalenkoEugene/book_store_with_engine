class AdminAbility
  include CanCan::Ability

  def initialize(user)
    user ||= Adminser.new
    can :manage, :all
  end
end
