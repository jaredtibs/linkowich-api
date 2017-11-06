require 'pusher'

Pusher.app_id = ENV['PUSHER_APP_ID']
Pusher.secret = ENV['PUSHER_APP_SECRET']
Pusher.key = ENV['PUSHER_API_KEY']
Pusher.cluster = 'us2'
Pusher.logger = Rails.logger
Pusher.encrypted = true
