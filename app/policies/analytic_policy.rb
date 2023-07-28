class AnalyticPolicy < ApplicationPolicy
  def show_visits?
    user.present?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
