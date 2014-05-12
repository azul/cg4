MembershipPolicy = Struct.new(:user, :membership) do
  def show?
    membership.visible_to?(user)
  end
  alias_method :update?, :show?
  alias_method :edit?, :update?
  alias_method :destroy?, :update?

  # membership in this case probably is a membership association proxy
  # for a group user wants to join
  def create?
    true
  end

  def may?(action)
    self.send "#{action}?"
  end
end
