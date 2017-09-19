class UserSerializer < ActiveModel::Serializer
  attributes(
    :id,
    :email,
    :username,
    :avatar,
    :link_count
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

end
