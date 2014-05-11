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

  def may?(action)
    self.send "#{action}?"
  end

  def actions
    [:edit, :destroy].select{|a| may?(a)}.map do |action|
      ResourceAction.new(group, action)
    end
  end

end

ResourceAction = Struct.new(:resource, :action) do
  def translation_key
    "actions.#{resource.class.name.tableize}.#{action}"
  end

  def url_options
    if show? or destroy?
      resource
    else
      [action, resource]
    end
  end

  def html_options
    if destroy?
      {method: :delete, data: {confirm: 'Are you sure'}}
    else
      {}
    end
  end

  [:index, :show, :new, :edit, :destroy].each do |act|
    define_method("#{act}?") { action == act }
  end
end

