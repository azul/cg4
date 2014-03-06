class Group < ActiveRecord::Base

  RELATIONSHIPS = [:admin, :member, :user, :visitor]
  enum visibility: RELATIONSHIPS.map{|r| "visible_to_#{r}"}

  after_initialize :set_default_visibility, :if => :new_record?

  def set_default_visibility
    self.visibility ||= :visible_to_member
  end

  def visible_to?(user)
    read_attribute(:visibility) >= RELATIONSHIPS.index(relationship_to(user))
  end

  def relationship_to(user)
    case user
    when nil
      :visitor
    else
      :user
    end
  end

  def self.visible_to(user)
    if user.present?
      where "visibility > ?", 1
    else
      visible_to_visitor
    end
  end

  def display_name
    name
  end
end
