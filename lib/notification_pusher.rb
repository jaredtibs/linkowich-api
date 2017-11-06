class NotificationPusher
  class << self

    def send(link)
      Pusher.trigger("links", "#{link.user.id}-published", {
        message: { message: "#{link.user.username} published #{link.url}" }
      })
    end

  end
end
