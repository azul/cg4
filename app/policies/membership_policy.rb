MembershipPolicy = Struct.new(:user, :membership) do
  def show?
    membership.visible_to?(user)
  end
  alias_method :update?, :show?
  alias_method :edit?, :update?
  alias_method :destroy?, :update?
end
