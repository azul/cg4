class Relationship

  RELATIONSHIPS = [:myself, :friend, :peer, :user, :visitor]

  attr_accessor :user

  def initialize(user)
    @user = user
  end

  def self.all
    RELATIONSHIPS
  end

  def distance_to(other)
    RELATIONSHIPS.index(self.to(other))
  end

  def to(other)
    RELATIONSHIPS.find do |rel|
      self.send "is_#{rel}?".to_sym, other
    end
  end

  def is_myself?(other)
    other == user
  end

  def is_friend?(other)
    user.has_friend?(other)
  end

  def is_peer?(other)
    user.has_peer?(other)
  end

  def is_user?(other)
    other.present?
  end

  def is_visitor?(other)
    other.blank?
  end

end
