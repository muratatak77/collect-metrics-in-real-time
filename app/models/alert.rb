class Alert < ApplicationRecord
	belongs_to :threshold, optional: false

	enum status: {
		:open => "open", 
		:acknowledged => "acknowledged", 
		:resolved => "resolved"
	}


	def self.status_open
		Alert.statuses[:open]
	end


	def self.status_acknowledged
		Alert.statuses[:acknowledged]
	end

	def self.resolved
		Alert.statuses[:resolved]
	end

end