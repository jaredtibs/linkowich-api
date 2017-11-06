class NotificationPusher
  class << self

    def send(link)
      Pusher.trigger("links", "#{link.user.id}_published", {
        message: { user_id: link.user.id, link_id: link.id }
      })
    end

  end
end
