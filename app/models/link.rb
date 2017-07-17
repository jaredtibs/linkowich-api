class Link < ApplicationRecord
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
