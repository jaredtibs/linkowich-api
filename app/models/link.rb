class Link < ApplicationRecord
  acts_as_votable

  belongs_to :user
  validates_with UrlValidator

  def serialized_user
    if user
      ActiveModelSerializers::SerializableResource.new(user, serializer: UserSerializer)
    else
      {}
    end
  end

end
