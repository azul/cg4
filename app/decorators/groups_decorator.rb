class GroupsDecorator < Draper::CollectionDecorator

  def title
    h.t(".directory")
  end

  def list
    h.render object.decorate
  end
end
