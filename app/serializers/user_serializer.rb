class UserSerializer < ActiveModel::Serializer
  attributes(
    :id,
    :email,
    :username,
    :avatar,
    :link_count,
    :upvotes
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

  def upvotes
    user.total_upvotes
  end

end
