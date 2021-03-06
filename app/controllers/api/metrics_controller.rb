require 'constant'
require 'redis_utils'

class Api::MetricsController < ApplicationController


=begin
  It is conceived to have an intense metric request.
  I decided using Redis becuase of I don't want to hit the database for every request.
  I collect data in the Redis until the redis increment count get % 5 or any number
  If I reach mod number == 0,  we can start a sidekiq active job, and I start to consume data in a sidekiq job.

  TODO : 1-) Redis INC function has max value. We need to reset when it will reach max number or any specific number
    => Redis can hold upto 2 power 63. and throws error if it exceeds that limit. It might be either "out of range" error or "overflow" error
    
    2-) If you have Sidekiq Enterprise we can use Rate Limiter settings.
    https://github.com/mperham/sidekiq/wiki/Ent-Rate-Limiting
=end

  def create
    render json: {status: :bad_request} unless params.present?
    key = RedisUtils.set_inc_and_get_redis_key
    set_params(key)
    $redis.set(key, params[:metric].to_json)
    if key.to_i % Constant::REDIS_INC_MOD == 0
      MetricJob.set(queue: :metric_data).perform_later()
    end
    render json: {data: "OK"}, status: 200
  end

  def index
    @metrics = Metric.all.order("created_at DESC").limit(100)
    render json: @metrics
  end

  private

  def set_params(key)
    params[:metric][:created_at] = DateTime.now.utc
    params[:metric][:updated_at] = DateTime.now.utc
    params[:metric][:redis_key] = key
  end

end
