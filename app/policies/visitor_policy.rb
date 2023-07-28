class VisitorPolicy < ApplicationPolicy
  def show_visitors_info?
    user.present?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
