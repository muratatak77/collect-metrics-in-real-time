class Threshold < ApplicationRecord
	validates :name, presence: true
	validates_uniqueness_of :name
  	validate :is_same?

	def is_same?
   		if self.min and self.max and self.min == self.max
   			errors.add(:base, "Min and Max can not be same!")
   		end
  	end

	def self.get_all_threshold_from_cache
		data = Rails.cache.fetch(generated_key) do
			get_all_treshold()
		end
		data
	end

	private

	def self.generated_key
	    count = Threshold.count()
	    max_updated_at = Threshold.maximum(:updated_at)
	    key = "tresholds-cache-list-"
	    key += "#{count}-#{max_updated_at}"
	    puts "Generated new tresholds cache using by key : #{key}"
	end

	def self.get_all_treshold
	    Threshold.all()
	end

end
