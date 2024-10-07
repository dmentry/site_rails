class ArticlePolicy < ApplicationPolicy
  def show?
    record.is_visible || (!record.is_visible && user.present?)
  end

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

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
