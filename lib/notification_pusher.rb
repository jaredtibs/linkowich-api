class NotificationPusher
  class << self

    def send(user, link)
      Pusher.trigger("link_published", "#{user.id}_published", {
        message: { user_id: user.id, link_id: link.id }
      })
    end

  end
end
