require 'rails_helper'
require 'sidekiq/testing'

RSpec.describe "Metrics", type: :request do

	data = File.read("spec/input.json")

	describe "POST /metrics" do
		it "returns http success" do

			headers = { "ACCEPT" => "application/json" }
			post "/api/metrics", :params => data, :headers => headers
			expect(response).to have_http_status(:success)
			expect(MetricJob).to be_processed_in :metric_data # or
   end

  end

end
