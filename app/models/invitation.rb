class Invitation < ApplicationRecord
  belongs_to :sender, class_name: 'User', foreign_key: 'sender_id'

  def serialized_sender
    if sender
      ActiveModelSerializers::SerializableResource.new(
        sender, serializer: UserSerializer
      )
    end
  end
end
