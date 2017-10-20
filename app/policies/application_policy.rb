class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    user.role.has_permission?(record.class.name, :index)
  end
  
  def show?
    user.role.has_permission?(record.class.name, :read)
  end
  
  def new?
    user.role.has_permission?(record.class.name, :create)
  end

  def create?
    user.role.has_permission?(record.class.name, :create)
  end
  
  def edit?
    user.role.has_permission?(record.class.name, :update)
  end

  def update?
    user.role.has_permission?(record.class.name, :update)
  end
  
  def destroy?
    user.role.has_permission?(record.class.name, :destroy)
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
      scope
    end
  end
end
