class FriendSerializer < UserSerializer

  attributes :is_following

  def is_following
    current_user.follows?(user.id)
  end

end
