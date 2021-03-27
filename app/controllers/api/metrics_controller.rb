require 'constant'

class Api::MetricsController < ApplicationController
	
	def create
		
		puts "params : #{params}"
		render json: {status: :bad_request} unless params.present?

		#I decided using Redis becuase of I don't want to hit the database for every request.
		#I collect data in the Redis until the redis increment count get % 5 
		#If I reach mod number == 0,  we can start a sidekiq active job, and I start to consume data in redis
		
		#TODO : Redis INC function has max value. We need to reset when it will reach max number or any specific number
		# 		=> Redis can hold upto 2 power 63. and throws error if it exceeds that limit. It might be either "out of range" error or "overflow" error
		key = get_inc_redis_key
		set_params(key)
		$redis.set(key, params.to_json)

		if key.to_i % Constant::REDIS_INC_MOD == 0
		# 	# start sidekiq operation to process using by queue
			MetricJob.set(queue: :metric_data).perform_later()
			# if MetricJob.set(queue: :metric_data).perform_later()
			# 	render json: {data: "OK"}, status: 200 
			# else
			# 	render json: {data: "FAIL", status: :unprocessable_entity}
			# end
		end
	end

	private

	def get_inc_redis_key
		$redis.incr("metric_count")
		key = $redis.get("metric_count")
		puts "Genarete key : #{key}"
		key
	end

	def set_params(key)
		params[:created_at] = DateTime.now.utc
		params[:updated_at] = DateTime.now.utc
		params[:redis_key] = key
		puts "Genarete params object : #{params}"
	end

end