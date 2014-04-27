GroupPolicy = Struct.new(:user, :group) do
  self::Scope = Struct.new(:user, :scope) do
    def resolve
      scope.visible_to(user)
    end
  end

  def show?
    group.visible_to?(user)
  end

  def update?
    group.memberships.exists?(user_id: user)
  end
  alias_method :edit?, :update?
  alias_method :destroy?, :update?
end
