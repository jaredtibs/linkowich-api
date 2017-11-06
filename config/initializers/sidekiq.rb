require 'sidekiq/web'

Sidekiq.configure_server do |config|
  concurrency = ENV.fetch('SIDEKIQ_CONCURRENCY', '2').to_i
  config.options[:concurrency] = concurrency
  config.redis = { namespace: "sidekiq", size: concurrency + 2 }
end

Sidekiq.configure_client do |config|
  config.redis = { namespace: "sidekiq" }
end

Sidekiq::Web.use(Rack::Auth::Basic) do |user, password|
  [user, password] == ["admin", "linkowich!!1"]
end
