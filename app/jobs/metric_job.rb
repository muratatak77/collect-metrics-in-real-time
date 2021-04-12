require 'constant'
require 'redis_utils'

class MetricJob < ApplicationJob

=begin
	In this class , I start to iterate over the redis increment key as reverse sorted. 
	In Metrics Controller class, I kept until the 'Constant::REDIS_INC_MOD'

	By doing a reverse order, I start to process the data I hold in Redis.
	I compare it with redis_key within each item for a safer operation.
	Finally, with the method in the Metric class, I turn each item into a Metric object.
	I save my data in a global result array in a batch way and once in DB. ("def create_metrics (result)") 
	
	After registering to DB, I call FindThresholdsAlertJob. This job will compare the respective metrics with the thresholds we have at our disposal.
	Then I delete the data I process from the redis to prevent bloat inside Redis.
=end
  queue_as :metric_data

  def perform()
    @sending_email_list = []
    set_max_number_from_redis
    start()
  end

  private

  def start()
    result = []
    _start = @max_number-(Constant::REDIS_INC_MOD-1)
    _end =  @max_number

    #By doing a reverse order, I start to process the data I hold in Redis.
    (_start.._end).reverse_each do |id|
      puts "REDIS - GET ID : #{id}"
      value = $redis.get(id)
      next unless value.present?

      value = JSON.parse(value)
      puts "Value Redis Key : #{value["redis_key"]}"

      #I compare it with redis_key within each item for a safer operation.
      next if value["redis_key"].to_i != id

      result << Metric.get_object(value)
    end
    create_metrics(result)
  end


=begin
We have a bunch of data and we don't need to hit to the DB every item. 
We can use another gem 'activerecord-import'.
Activerecord-Import is a library for bulk inserting data using ActiveRecord.
https://github.com/zdennis/activerecord-import
=end
  def create_metrics(result)
    puts "Metrics will be created object of metrics array: #{result}"
    response = Metric.import! result  # or use import!
    if response
      clear_redis()
      if Rails.env.test?
        return result
      end
      #After registering to DB, I call FindThresholdsAlertJob. This job will compare the respective metrics with the thresholds we have at our disposal.
      FindThresholdsAlertJob.set(queue: :threshold_find).perform_now(JSON.dump(result))
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
    @max_number = RedisUtils.get_inc_key
    puts "START Metric JOB - max_number : #{@max_number}"
    return "ERROR - Invalid Max Number" if @max_number.to_i == 0
    @max_number = @max_number.to_i
  end

end
