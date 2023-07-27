class VisitorPolicy < ApplicationPolicy
  def show_visitors_info?
    user.present?
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
