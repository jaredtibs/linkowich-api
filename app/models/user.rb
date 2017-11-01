class User < ApplicationRecord
  acts_as_voter

  devise :database_authenticatable, :trackable, :recoverable
  mount_uploader :avatar, AvatarUploader

  has_many :follower_relationships, -> { order(created_at: :desc) }, foreign_key: :following_id, class_name: 'Follow'
  has_many :followers, through: :follower_relationships, source: :follower

  has_many :following_relationships, -> { order(created_at: :desc) }, foreign_key: :follower_id, class_name: 'Follow'
  has_many :following, through: :following_relationships, source: :following

  has_many :links
  has_many :invitations, foreign_key: 'sender_id'

  validates :username, presence: true, length: { minimum: 2 },
            uniqueness: { case_sensitive: false }, on: [:create, :update]

  validates_uniqueness_of :email
  validates_format_of :username, with: /^[a-zA-Z0-9_\.]*$/, :multiline => true
  validates :password, presence: true, length: { within: 8..20 }, on: :create

  before_create :generate_follow_code
  before_create :set_default_avatar_color
  before_create { self.email.downcase! }

  def self.find_for_database_authentication(identifier)
    find_by(username: identifier) || find_by(email: identifier)
  end

  def follow(user_id)
    following_relationships.find_or_create_by following_id: user_id
  end

  def unfollow(user_id)
    following_relationship = following_relationships.find_by following_id: user_id
    following_relationship ? following_relationship.destroy : false
  end

  def follows?(user_id)
    following_relationships.where(following_id: user_id).exists?
  end

  def upvote(link)
    unless voted_for? link
      link.vote_by voter: self
      Link.increment_counter(:upvote_count, link.id)
    end
  end

  def unvote(link)
    if voted_for? link
      link.unvote_by self
      Link.decrement_counter(:upvote_count, link.id)
    end
  end

  def total_upvotes
    links.sum(:upvote_count)
  end

  def current_link
    links.where(current: true).first
  end

  def clear_current_link
    links.where(current: true).update_all(current: false)
  end

  def following_links
    Link.where("user_id IN (?)", following.pluck(:id))
      .where(current: true)
      .order('created_at desc')
  end

  def image_data=(data)
    # decode data and create stream on them
    io = CarrierStringIO.new(Base64.decode64(data))
    self.avatar = io
  end

  def has_unseen_invitations?
    Invitation.where(recipient_email: self.email, viewed: false).any?
  end

  private

  def generate_follow_code
    self.follow_code = SecureRandom.hex(5)
  end

  def default_avatar_colors
    %w(blue pink purple)
  end

  def set_default_avatar_color
    self.default_avatar_color = default_avatar_colors.sample
  end

end
