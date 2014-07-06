class GroupDecorator < Draper::Decorator
  delegate :memberships

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
