class CommentPolicy < ApplicationPolicy
  def destroy?
    user.present?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
