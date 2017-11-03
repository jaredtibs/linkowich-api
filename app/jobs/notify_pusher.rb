class NotifyPusher
  include Sidekiq::Worker
  sidekiq_options backtrace: true

  def perform(link_id)
    link = Link.find_by id: link_id
    NotificationPusher.send link if link
  end
end
