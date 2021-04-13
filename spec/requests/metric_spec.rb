require 'rails_helper'
require 'sidekiq/testing'

RSpec.describe "Metrics", type: :request do

  Threshold.create(name: "ingresscount",min: 3000, max: 80000)
  Threshold.create(name: "memused",min: 20000, max: 80000)

  data  =
  [
    {"txcount":27887,"netpeers":31847,"ingresscount":84059,"egresscount":2081,"procload":41318,"sysload":54425,"syswait":22540,"threads":40456,"writebytes":3300,"readbytes":10694,"memallocs":78511,"memfrees":28162,"mempauses":55089,"memused":24728},
    {"txcount":11211,"netpeers":31445,"ingresscount":23237,"egresscount":39106,"procload":40495,"sysload":65466,"syswait":11528,"threads":86258,"writebytes":58047,"readbytes":79947,"memallocs":38287,"memfrees":32888,"mempauses":92790,"memused":93015},
    {"txcount":74078,"netpeers":64324,"ingresscount":16159,"egresscount":71353,"procload":51957,"sysload":43721,"syswait":27189,"threads":82199,"writebytes":13000,"readbytes":38705,"memallocs":62888,"memfrees":4538,"mempauses":49703,"memused":89355},
    {"txcount":8510,"netpeers":52605,"ingresscount":60156,"egresscount":28266,"procload":89828,"sysload":75561,"syswait":87202,"threads":34783,"writebytes":35746,"readbytes":71563,"memallocs":14376,"memfrees":89002,"mempauses":29718,"memused":25447},
    {"txcount":61577,"netpeers":7463,"ingresscount":67996,"egresscount":6420,"procload":18623,"sysload":60953,"syswait":71137,"threads":43133,"writebytes":79241,"readbytes":70059,"memallocs":53033,"memfrees":38643,"mempauses":53891,"memused":2002}
  ]

  describe "POST /metrics" do
    it "returns http success" do

      headers = { "ACCEPT" => "application/json" }
      data.each do |item|
        post "/api/metrics", :params => {metric: item}, :headers => headers, as: :json
        expect(response).to have_http_status(:success)
      end
      sleep(1)
      result = MetricJob.perform_now()
      sleep(1)
      expect(Metric.count).to equal(5)
      FindThresholdsAlertJob.perform_now(JSON.dump(result))
      sleep(1)
      expect(Alert.count).to be > 0

    end

  end

end
