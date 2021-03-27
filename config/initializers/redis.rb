$redis = Redis.new(:host => "127.0.0.1", :port => 6379)
puts " ========= REDIS  INITIALIZE ====== : #{$redis}"


# require 'sidekiq-rate-limiter/version'
# require 'sidekiq-rate-limiter/fetch'

# Sidekiq.configure_server do |config|
#   Sidekiq.options[:fetch] = Sidekiq::RateLimiter::Fetch
# end


