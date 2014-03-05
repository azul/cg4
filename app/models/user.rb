class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  enum role: [:user, :vip, :admin]
  enum visibility: [:hidden, :visible_to_friends, :visible_to_peers, :visible_to_users, :visible_to_public]

  after_initialize :set_default_role, :if => :new_record?
  after_initialize :set_default_visibility, :if => :new_record?

  def set_default_role
    self.role ||= :user
  end

  def set_default_visibility
    self.visibility ||= :visible_to_peers
  end

  def visible_to?(other_user)
    if other_user.present?
      visible_to_users?
    else
      visible_to_public?
    end
  end

  def visible_to(other_user)
    if other_user.present?
      visible_to_users
    else
      visible_to_public
    end
  end

  def display_name
    self.name || self.email.split('@').first
  end
end
