class AboutPolicy < ApplicationPolicy
  def create?
    user.present?
  end

  def new?
    create?
  end

  def update?
    create?
  end

  def destroy?
    create?
  end

  def index?
    create?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
