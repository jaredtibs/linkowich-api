class LinkSerializer < ActiveModel::Serializer
  attributes(
    :id,
    :url,
    :user
  )

  def link
    @link ||= object
  end

  def type
    link.class.name
  end

end
