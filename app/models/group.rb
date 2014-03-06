class Group < ActiveRecord::Base

  enum visibility: [:hidden, :visible_to_users, :visible_to_public]

  after_initialize :set_default_visibility, :if => :new_record?

  def set_default_visibility
    self.visibility ||= :hidden
  end

  def visible_to?(user)
    if user.present?
      visible_to_users?
    else
      visible_to_public?
    end
  end

  def self.visible_to(user)
    if user.present?
      visible_to_users
    else
      visible_to_public
    end
  end

  def display_name
    name
  end
end
