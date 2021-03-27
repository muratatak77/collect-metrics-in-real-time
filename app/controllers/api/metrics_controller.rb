require 'constant'

class Api::MetricsController < ApplicationController
	
	def create
		puts "params : #{params}"

		render json: {status: :bad_request} unless params.present?

		metric = Metric.get_object(params, is_new:true)
		if MetricJob.set(queue: :metric_data).perform_later(JSON.dump(metric))
			render json: {status: 200}
		else
			render json: {status: :unprocessable_entity}
		end
		
	end

end