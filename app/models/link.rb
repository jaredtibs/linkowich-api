class Link < ApplicationRecord
  acts_as_votable

  belongs_to :user
  before_validation :smart_add_url_protocol
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

  def smart_add_url_protocol
    unless self.url[/^https?:\/\//] || self.url[/^http?:\/\//]
      self.url = "http://#{self.url}"
    end
  end

  def trigger_pusher_event
    NotifyPusher.perform_async self.id
  end

end
