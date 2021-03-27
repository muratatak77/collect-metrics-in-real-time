require 'constant'

class MetricJob < ApplicationJob

	queue_as :metric_data

	def perform()
		set_max_number_from_redis
		start()
	end

	private 

	def start()
		# puts "data : #{data}"
		# Metric.create_metric(data)
		result = []
	  	_start = @max_number-(Constant::REDIS_INC_MOD-1)
	  	_end =  @max_number

	  	(_start.._end).reverse_each do |id|
	  		puts "REDIS - GET ID : #{id}"
	  		value = $redis.get(id)

	  		puts "Value : #{value}"
	  		next unless value.present?

	  		value = JSON.parse(value)
	  		puts "Value Redis Key : #{value["redis_key"]}"

	  		next if value["redis_key"].to_i != id

	  		result << Metric.get_object(value)
	  		puts "========================="
	  	end
	  	create_metrics(result)
	end


# =begin
# We have a bunch of data and we don't need to hit to the DB every item. 
# We can use another gem 'activerecord-import'.
# Activerecord-Import is a library for bulk inserting data using ActiveRecord.
# https://github.com/zdennis/activerecord-import
# =end
	def create_metrics(result)
		response = Metric.import! result  # or use import!
		puts "Metrics will be created object of campaigns array: #{result}"
		if response
			clear_redis()
			puts "Success - All metrics were created."
		else
			puts "Fail object of metrics created : ERR: #{response.errors}"
		end
	end

	def clear_redis
		_start = @max_number-(Constant::REDIS_INC_MOD-1)
		_end =  @max_number
		(_start.._end).reverse_each do |id|
			if $redis.del(id)
				puts "REDIS CLEARED BY ID : #{id}"
			end
		end
	end

	def set_max_number_from_redis
		@max_number = $redis.get("metric_count")
		puts "START Metric JOB - max_number : #{@max_number}"
		return "ERROR - Invalid Max Number" if @max_number.to_i == 0
	  	@max_number = @max_number.to_i
	end

end
