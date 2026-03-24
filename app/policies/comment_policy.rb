class CommentPolicy < ApplicationPolicy
  def edit?
    user.present?
  end

  def update?
    user.present?
  end

  def destroy?
    user.present?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
