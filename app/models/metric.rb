class Metric < ApplicationRecord

	validates_presence_of :memused, :mempauses
	
	def self.create_metric(data)
		metric = Metric.new(get_object(data))
		puts  "Prepared metric object : #{metric.to_json}"
		if metric.save!
			puts "SAVE - Success : Metric :  #{metric.to_json}"
		else
			puts "SAVE - ERROR . Message : #{metric.errors.to_json}"
		end
	end


	def self.get_object(params, is_new: false)
		temp = {
			txcount: params["txcount"],
			netpeers: params["netpeers"],
			ingresscount: params["ingresscount"],
			egresscount: params["egresscount"],
			procload: params["procload"],
			sysload: params["sysload"],
			syswait: params["syswait"],
			threads: params["threads"],
			writebytes: params["writebytes"],
			readbytes: params["readbytes"],
			memallocs: params["memallocs"],
			memfrees: params["memfrees"],
			mempauses: params["mempauses"],
			memused: params["memused"],	
			created_at: params["created_at"],
			updated_at: params["updated_at"]
		}
		if is_new
			temp[:created_at] =  DateTime.now.utc
			temp[:updated_at] =  DateTime.now.utc
		end
		puts "Generated temp object : #{temp}"
		temp
	end
	

end