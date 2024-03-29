class UserSerializer < ActiveModel::Serializer
  attributes(
    :id,
    :email,
    :username,
    :avatar,
    :link_count,
    :upvotes,
    :follow_code,
    :following_ids,
    :unseen_invitations,
    :default_avatar_color
  )

  def user
    @user ||= object
  end

  def type
    user.class.name
  end

  def link_count
    user.links.visible.count
  end

  def upvotes
    user.total_upvotes
  end

  def following_ids
    user.following.pluck(:id)
  end

  def unseen_invitations
    user.has_unseen_invitations?
  end

end
