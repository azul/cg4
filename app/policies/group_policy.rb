GroupPolicy = Struct.new(:user, :group) do
  self::Scope = Struct.new(:user, :scope) do
    def resolve
      scope.visible_to(user)
    end
  end
end
