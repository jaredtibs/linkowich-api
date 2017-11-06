require 'pusher'

$pusher_client = Pusher::Client.new(
  app_id: ENV['PUSHER_APP_ID'],
  key: ENV['PUSHER_API_KEY'],
  secret: ENV['PUSHER_APP_SECRET'],
  cluster: 'us2',
  logger: Rails.logger,
  encrypted: true
)

=begin
Pusher.app_id = ENV['PUSHER_APP_ID']
Pusher.secret = ENV['PUSHER_APP_SECRET']
Pusher.key = ENV['PUSHER_API_KEY']
Pusher.cluster = 'us2'
Pusher.logger = Rails.logger
Pusher.encrypted = true
=end
