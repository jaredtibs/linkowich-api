REDIS_CONFIG = YAML.load( File.open( Rails.root.join("config/redis.yml") ) ).symbolize_keys
default = REDIS_CONFIG[:default].symbolize_keys
config  = default.merge(REDIS_CONFIG[Rails.env.to_sym].symbolize_keys) if REDIS_CONFIG[Rails.env.to_sym]

if Rails.env.production? || Rails.env.staging?
  redis = Redis.new(url: ENV['OPENREDIS_URL'])
  namespace = ENV['REDIS_NAMESPACE']
else
  redis = Redis.new(config)
  namespace = config[:namespace]
end

$redis = Redis::Namespace.new(namespace, redis: redis)
