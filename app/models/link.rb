class Link < ApplicationRecord
  acts_as_votable

  belongs_to :user
  validates_with UrlValidator

  after_commit :trigger_pusher_event, on: :create

  def serialized_user
    if user
      ActiveModelSerializers::SerializableResource.new(user, serializer: UserSerializer)
    else
      {}
    end
  end

  private

  def trigger_pusher_event
    NotifyPusher.perform_async self.id
  end

end
