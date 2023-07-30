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

  def show_visits?
    show?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
