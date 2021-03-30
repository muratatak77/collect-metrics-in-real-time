class RedisUtils

	def self.set_inc_and_get_redis_key
		key_part = init
		$redis.incr("metric_count_#{key_part}")
		key = $redis.get("metric_count_#{key_part}")
		puts "Genarete key : #{key}"
		key
	end


	def self.get_inc_key
		key_part = init
		$redis.get("metric_count_#{key_part}")
	end

	private

	def self.init
		key_part = "dev_"
		key_part = "test_" if Rails.env.test?
		key_part
	end

end