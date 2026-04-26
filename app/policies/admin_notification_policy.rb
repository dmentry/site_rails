class AdminNotificationPolicy < ApplicationPolicy
  def index?
    user.present? && user.admin?
  end

  def show?
    index?
  end

  def destroy?
    index?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
