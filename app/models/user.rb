class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  enum role: [:user, :vip, :admin]
  enum visibility: Relationship.all.map{|r| "visible_to_#{r}"}

  has_many :memberships
  has_many :groups, through: :memberships

  attr_accessor :friend_ids, :peer_ids

  after_initialize :set_default_role, :if => :new_record?
  after_initialize :set_default_visibility, :if => :new_record?

  def set_default_role
    self.role ||= :user
  end

  def set_default_visibility
    self.visibility ||= :visible_to_peer
  end

  def visible_to?(other)
    read_attribute(:visibility) >= relationship.distance_to(other)
  end

  def relationship
    @relationship ||= Relationship.new(self)
  end

  def has_friend?(other)
    friend_ids && friend_ids.include?(other.id)
  end

  def has_peer?(other)
    peer_ids && peer_ids.include?(other.id)
  end

  def self.visible_to(other_user)
    if other_user.present?
      visible_to_user
    else
      visible_to_visitor
    end
  end

  def display_name
    self.name || self.email.split('@').first
  end
end
