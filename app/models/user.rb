class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  enum role: [:user, :vip, :admin]
  RELATIONSHIPS = [:self, :friend, :peer, :user, :visitor]
  enum visibility: RELATIONSHIPS.map{|r| "visible_to_#{r}"}

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
    read_attribute(:visibility) >= RELATIONSHIPS.index(relationship_to(other))
  end

  def relationship_to(user)
    case user
    when nil    then :visitor
    when self   then :self
    when friend then :friend
    when peer   then :peer
    else :user
    end
  end

  def friend
    ->x {self.has_friend?(x)}
  end

  def has_friend?(other)
    friend_ids && friend_ids.include?(other.id)
  end

  def peer
    ->x {self.has_peer?(x)}
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
