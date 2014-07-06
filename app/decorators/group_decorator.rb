class GroupDecorator < Draper::Decorator
  delegate :memberships

  def cache_key(user)
    [object, object.relationship_to(user)]
  end

  def to_key
    [object.to_key]
  end

  def haml_object_ref
    object.class
  end

  def title
    h.link_to object.name, object
  end

  def overview_actions
    h.render 'layouts/actions/list', actions: policy.actions
  end

  def visibility
    h.t ".#{object.visibility}"
  end

  def members
    h.render object.users
  end

  def allowed_actions_for(user)
    actions_for(user).select do |action|
      action.allowed_to? user
    end
  end

  def actions_for(user)
    action = ActionFactory.new
    action.edit group
    action.destroy group
    action.destroy group.memberships.where(user: user).first
    action.create group.memberships
    action.index group.class
  end

  protected
  def policy
    h.policy(object)
  end
end
