class Membership < ActiveRecord::Base

  belongs_to :group
  belongs_to :user
  validates :group, presence: true
  validates :user, presence: true

  def visible_to?(viewer)
    user == viewer or group.has_member?(viewer)
  end
end
