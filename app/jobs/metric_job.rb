class MetricJob < ApplicationJob
  queue_as :metric_data

  def perform(data)
  	return if data.nil?
  	data = JSON.load(data)
  	start(data)
  end

	private 

	def start(data)
		puts "data : #{data}"
		Metric.create_metric(data)
	end

end
