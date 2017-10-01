class LinkSerializer < ActiveModel::Serializer
  include ActionView::Helpers::DateHelper

  attributes(
    :id,
    :created_at,
    :published_at,
    :published_ago,
    :url,
    :seen_by,
    :user
  )

  def link
    @link ||= object
  end

  def type
    link.class.name
  end

  def user
    link.serialized_user
  end

  def published_at
    link.created_at
      .in_time_zone("Pacific Time (US & Canada)")
      .strftime("%^B %d, %Y|%-l:%M %p")
  end

  def published_ago
    time_ago_in_words(link.created_at)
  end

  def seen_by
    usernames = User.where(id: link.seen_by).pluck(:username)
    usernames.map { |name| name == current_user.username ? 'You' : name }
  end

end
