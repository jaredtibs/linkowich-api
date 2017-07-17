class LinkSerializer < ActiveModel::Serializer
  attributes(
    :id,
    :url,
    :user
  )

  def link
    @link ||= object
  end

  def user
    link.serialized_user
  end

end
