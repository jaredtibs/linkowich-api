class UserSerializer < ActiveModel::Serializer
  attributes(
    :id,
    :email,
    :username,
    :avatar,
    :current_link
  )

  def user
    @user ||= object
  end

  def type
    user.class.name
  end

  def current_link
    user.current_link
  end

end
