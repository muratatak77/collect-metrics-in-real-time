require 'constant'
require 'redis_utils'

class FindThresholdsAlertJob < ApplicationJob

	def perform(metrics)
		@sending_email_list = []
		@metrics = JSON.load(metrics)
		@thresholds = Threshold.get_all_threshold_from_cache
		puts "ALL @thresholds : #{@thresholds.to_json}"
		start
	end

	private 

	def start		

		# #<Threshold id: 8, name: "memused", min: 30000, max: 90000, created_at: "2021-03-29 21:28:02.989235000 +0000", updated_at: "2021-03-29 21:28:02.989235000 +0000">
		# 
		# 
		# 
		# [{:txcount=>9336, :netpeers=>72546, :ingresscount=>9107, :egresscount=>7940, 
		# :procload=>6503, :sysload=>30552, :syswait=>99843, :threads=>52205, :writebytes=>61598, :readbytes=>67425, 
		# :memallocs=>81351, :memfrees=>31515, :mempauses=>89757, :memused=>3687, 
		# :created_at=>"2021-03-30T18:54:04.763Z", :updated_at=>"2021-03-30T18:54:04.763Z"}, 
		# 
		#  {:txcount=>61577, :netpeers=>7463, :ingresscount=>67996, :egresscount=>6420, :procload=>18623,
		#  :sysload=>60953, :syswait=>71137, :threads=>43133, :writebytes=>79241, :readbytes=>70059,
		#  :memallocs=>53033, :memfrees=>38643, :mempauses=>53891, :memused=>2002, 
		#  :created_at=>"2021-03-30T18:54:01.757Z", :updated_at=>"2021-03-30T18:54:01.757Z"}, 
		#    
		#  {:txcount=>8510, :netpeers=>52605, :ingresscount=>60156, :egresscount=>28266, :procload=>89828, 
		#   :sysload=>75561, :syswait=>87202, :threads=>34783, :writebytes=>35746, :readbytes=>71563, :memallocs=>14376, 
		#   :memfrees=>89002, :mempauses=>29718, :memused=>25447, :created_at=>"2021-03-30T18:53:57.750Z", :updated_at=>"2021-03-30T18:53:57.750Z"},
		
		# _column_names = Metric.get_column_names_from_cache()

		keys = []
		@metrics.each do |mt|
			mt.each do |k,v|
				keys << k
			end
		end

		matches = @thresholds.all{|th| keys.include? th.name }
		puts "matches; #{matches.to_json}"
		return unless matches.present?

		@metrics.each do |metric|

			metric.each do |k,v|
					
				matches.each do |th|
					if k == th.name 

						# puts "th : #{th.to_json}"
						# puts "key : #{k} , v : #{v}"
						# puts "v < th.min : #{v < th.min}"
						# puts "v < th.max : #{v < th.max}"

						if (th.min.present? and v < th.min) or (th.max.present? and th.max < v)
							temp = {
								treshold_id: th.id,
								metric: metric
							}
							unless @sending_email_list.include? temp
								# puts "Adding ...."
								@sending_email_list << temp
							end
						end
					end
				end
			end
		end

		puts "sending_email_list; #{@sending_email_list}"

	end

end
