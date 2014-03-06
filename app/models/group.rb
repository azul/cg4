class Group < ActiveRecord::Base

  enum visibility: [:visible_to_member, :visible_to_user, :visible_to_visitor]

  after_initialize :set_default_visibility, :if => :new_record?

  def set_default_visibility
    self.visibility ||= :visible_to_member
  end

  def visible_to?(user)
    if user.present?
      visible_to_user? || visible_to_visitor?
    else
      visible_to_visitor?
    end
  end

  def self.visible_to(user)
    if user.present?
      where visibility: 1..2
    else
      visible_to_visitor
    end
  end

  def display_name
    name
  end
end
