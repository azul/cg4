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
    case other
    when nil    then :visitor
    when myself then :myself
    when friend then :friend
    when peer   then :peer
    else :user
    end
  end

  def myself
    ->x {x == user}
  end

  def friend
    ->x {user.has_friend?(x)}
  end

  def peer
    ->x {user.has_peer?(x)}
  end

end
