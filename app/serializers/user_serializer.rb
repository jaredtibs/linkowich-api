class UserSerializer < ActiveModel::Serializer
  attributes(
    :id,
    :email,
    :username,
    :avatar
  )

  def user
    @user ||= object
  end

  def type
    user.class.name
  end

end
