class GroupDecorator < Draper::Decorator

  def cache_key(user)
    [object, object.relationship_to(user)]
  end

  def to_key
    [object.id]
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


  def detail_actions(user)
    h.render_allowed_actions do |action|
      action.edit group
      action.destroy group
      action.destroy group.memberships.where(user: user).first
      action.create group.memberships
      action.index group.class
    end
  end

  def allowed_actions(actions)
    actions.map do |group|
      group.map do |action, resource|
        ResourceAction.new(resource, action)if h.policy(resource).may? action
      end
    end.flatten.compact
  end

  def visibility
    h.t ".#{object.visibility}"
  end

  def members
    h.render object.users
  end

  protected
  def policy
    h.policy(object)
  end
end
