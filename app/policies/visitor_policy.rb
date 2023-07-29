class VisitorPolicy < ApplicationPolicy
  def show_visitors_info?
    user.present?
  end

  def show_visitor_info?
    user.present?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
