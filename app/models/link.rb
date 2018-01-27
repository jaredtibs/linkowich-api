class Link < ApplicationRecord
  acts_as_votable

  belongs_to :user
  validates_with UrlValidator

  after_commit :trigger_pusher_event, on: :create

  scope :visible, -> { where(hidden: false) }
  scope :hidden,  -> { where(hidden: true)  }
  scope :current, -> { where(current: true) }

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
