class UserPolicy < ApplicationPolicy
  def show?
    user.present?
  end

  def edit?
    show?
  end

  def update?
    show?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
