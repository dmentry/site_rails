class PhotoPolicy < ApplicationPolicy
  def create?
    user.present?
  end

  def new?
    create?
  end

  def update?
    create?
  end

  def destroy?
    create?
  end

  def all_page?
    create?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
