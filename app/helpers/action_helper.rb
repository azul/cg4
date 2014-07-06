module ActionHelper

  def link_to_action(action)
    text = t(action.translation_key)
    link_to text, action.url_options, action.html_options
  end

  def render_allowed_actions(&block)
    render allowed_actions(&block)
  end

  def allowed_actions
    factory = ActionFactory.new
    yield factory
    factory.select do |action|
      action.allowed_to? current_user
    end
  end

  class ActionFactory

    def initialize
      @content = []
    end

    def edit(object)
      apply(object, :edit)
    end

    def create(object)
      apply(object, :create)
    end

    def destroy(object)
      apply(object, :destroy)
    end

    def index(object)
      apply(object, :index)
    end

    def apply(object, action)
      @content << action_class_for(object, action).new(object, action)
    end

    def select(&block)
      @content.select(&block)
    end

    def action_class_for(object, action)
      if object.respond_to? :proxy_association
        ProxyAction
      else
        ResourceAction
      end
    end
  end
end

module ActionTests
  [:index, :show, :new, :create, :edit, :update, :destroy].each do |act|
    define_method("#{act}?") { action == act }
  end

  def to_partial_path
    "layouts/actions/list_item"
  end

end

ResourceAction = Struct.new(:resource, :action) do
  include ActionTests

  def allowed_to?(user)
    resource && Pundit.policy(user, resource).may?(action)
  end

  def translation_key
    "actions.#{resource.class.name.tableize}.#{action}"
  end

  def url_options
    if show? or destroy? or index?
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
end

ProxyAction = Struct.new(:proxy, :action) do
  include ActionTests

  def allowed_to?(user)
    Pundit.policy(user, proxy).may? action
  end

  def translation_key
    "actions.#{proxy.klass.name.tableize}.#{action}"
  end

  def url_options
    if show? or destroy? or create?
      [owner, proxy.klass]
    else
      [action, proxy.klass]
    end
  end

  def html_options
    if destroy?
      {method: :delete, data: {confirm: 'Are you sure'}}
    elsif create?
      {method: :post}
    else
      {}
    end
  end

  def owner
    proxy.proxy_association.owner
  end
end

