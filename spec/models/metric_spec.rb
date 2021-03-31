require 'rails_helper'

RSpec.describe Metric, :type => :model do
	# pending "add some examples to (or delete) #{__FILE__}"
	
	subject {
		described_class.new(
			{
			txcount: 27887,
			netpeers: 31847,
			ingresscount: 84059,
			egresscount: 2081,
			procload: 41318,
			sysload: 54425,
			syswait: 22540,
			threads: 40456,
			writebytes: 3300,
			readbytes: 10694,
			memallocs: 78511,
			memfrees: 28162,
			mempauses: 55089,
			memused: 24728
		}
		)
	}

	it "is valid with valid attributes" do
  		expect(subject).to be_valid
	end


	it "is valid with valid attributes" do
		subject.memused = nil
  		expect(subject).to_not be_valid
	end

	it "is valid create with valid attributes" do
		metric = Metric.create(txcount: 27887,netpeers: 31847, ingresscount: 84059,mempauses: 55089,memused: 24728)
  		expect(metric).to be_valid
	end

end
