class UserPolicy < ApplicationPolicy
  def show?
    user.present? || user.admin?
  end

  def edit?
    false
  end

  def update?
    false
  end

  def show_visits?
    show?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
