require 'rails_helper'

RSpec.describe Threshold, type: :model do

	subject {
		described_class.new(
			{
			name: "memused",
			min: 31847,
			max: 84059
			}
		)
	}


	it "is valid with valid attributes" do
		subject.name = nil
  		expect(subject).to_not be_valid
	end

	it "is valid create with valid and not valid attributes" do
		th = Threshold.create(name: "memused",min: 31847, max: 84059)
  		expect(th).to be_valid

  		th2 = Threshold.create(name: "memused",min: 31847, max: 84059)
  		expect(th2).to_not be_valid
	end

	it "is not valid create" do
  		th = Threshold.create(name: "ingresscount",min: 100, max: 100)
  		expect(th).to_not be_valid
  	end

end
