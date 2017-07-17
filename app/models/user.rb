class User < ApplicationRecord
  devise :database_authenticatable, :trackable, :recoverable
  mount_uploader :avatar, AvatarUploader

  has_many :follower_relationships, foreign_key: :following_id, class_name: 'Follow'
  has_many :followers, through: :follower_relationships, source: :follower

  has_many :following_relationships, foreign_key: :follower_id, class_name: 'Follow'
  has_many :following, through: :following_relationships, source: :following

  has_many :links

  def follow(user_id)
    following_relationships.create following_id: user_id
  end

  def unfollow(user_id)
    following_relationship = following_relationships.find_by following_id: user_id
    following_relationship ? following_relationship.destroy : false
  end

  def current_link
    links.where(current: true).first
  end

  def following_links
    following.joins(:links)
      .where('links.current = true').pluck :url
  end

  def image_data=(data)
    # decode data and create stream on them
    io = CarrierStringIO.new(Base64.decode64(data))
    self.avatar = io
  end

end
