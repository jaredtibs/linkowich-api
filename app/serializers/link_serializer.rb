class LinkSerializer < ActiveModel::Serializer
  include ActionView::Helpers::DateHelper

  attributes(
    :id,
    :published_at,
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
    time_ago_in_words(link.created_at)
  end

  def seen_by
    User.where(id: link.seen_by).pluck(:username)
  end

end
