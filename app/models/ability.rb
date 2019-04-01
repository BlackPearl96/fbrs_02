class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    if user.admin?
      can :manage, :all
      cannot :destroy, User, id: user.id
    elsif user.user?
      can :read, :all
      can :update, User, user_id: user.id
      can :manage, Suggest
      can [:show, :filter], Book
      can :manage, Review, user_id: user.id
      can :manage, Comment, user_id: user.id
      can [:create, :destroy], Like
    else
      can :read, Book
      can :read, Category
    end
  end
end
