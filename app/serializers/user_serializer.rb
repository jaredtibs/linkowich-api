class UserSerializer < ActiveModel::Serializer
  attributes(
    :id,
    :email,
    :username,
    :avatar,
    :link_count,
    :is_following
  )

  def user
    @user ||= object
  end

  def type
    user.class.name
  end

  def link_count
    user.links.count
  end

  def is_following
    current_user.follows?(user.id)
  end

end
