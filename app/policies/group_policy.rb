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

  def new?
    !!user
  end

  def index?
    true
  end

  def may?(action)
    self.send "#{action}?"
  end

  def actions
    [:edit, :destroy].select{|a| may?(a)}.map do |action|
      ResourceAction.new(group, action)
    end
  end

end

