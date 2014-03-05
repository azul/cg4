UserPolicy = Struct.new(:user, :me) do
  self::Scope = Struct.new(:user, :scope) do
    def resolve
      scope.visible_to(user)
    end
  end

  def show?
    me.visible_to?(user)
  end

  def update?
    user.admin?
  end

  def destroy?
    user.admin?
  end

end
