class Group < ActiveRecord::Base

  RELATIONSHIPS = [:admin, :member, :user, :visitor]
  enum visibility: RELATIONSHIPS.map{|r| "visible_to_#{r}"}

  after_initialize :set_default_visibility, :if => :new_record?
  validates :name, presence: true

  has_many :memberships
  has_many :users, through: :memberships

  def set_default_visibility
    self.visibility ||= :visible_to_member
  end

  def visible_to?(user)
    read_attribute(:visibility) >= RELATIONSHIPS.index(relationship_to(user))
  end

  def relationship_to(user)
    case user
    when nil    then :visitor
    when member then :member
    else :user
    end
  end

  def member
    ->user {self.memberships.exists?(user_id: user.id)}
  end

  def self.visible_to(user)
    if user.present?
      joins("LEFT OUTER JOIN memberships on memberships.group_id = groups.id").
        where("(memberships.user_id = ?) OR (visibility > ?)", user.id, 1)
    else
      visible_to_visitor
    end
  end

  def display_name
    name
  end
end
