class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end



  def index?
    true
  end

  def show?
    visible_to_user?(record)
  end

  def create?
    belongs_to_user?(record)
  end

  def update?
    belongs_to_user?(record)
  end

  def destroy?
    belongs_to_user?(record)
  end



  def scope
    Pundit.policy_scope!(user, record.class)
  end



  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope.all
    end
  end



  ## Convenience methods
  def user_signed_in?
    user != nil
  end

  def belongs_to_user?(r)
    user_signed_in? && user == r.user
  end

  def visible_to_user?(r)
    r.user.nil? || belongs_to_user?(r)
  end
end
