require 'constant'
require 'redis_utils'

=begin
  The task of comparing the incoming metric data with the Threshold alert points we have.

  We get some metrics data and we need to compare to the thresholds data.
  If we have out of range , we need to create an alert. 
  And finally we will start an email process using by notifier job.

  We get like these metric data from metric job

  [
   {:txcount=>9336, :netpeers=>72546, :ingresscount=>9107, :egresscount=>7940, 
   :procload=>6503, :sysload=>30552, :syswait=>99843, :threads=>52205, :writebytes=>61598, :readbytes=>67425, 
   :memallocs=>81351, :memfrees=>31515, :mempauses=>89757, :memused=>3687, 
   :created_at=>"2021-03-30T18:54:04.763Z", :updated_at=>"2021-03-30T18:54:04.763Z"}, 
   
   {:txcount=>61577, :netpeers=>7463, :ingresscount=>67996, :egresscount=>6420, :procload=>18623,
    :sysload=>60953, :syswait=>71137, :threads=>43133, :writebytes=>79241, :readbytes=>70059,
    :memallocs=>53033, :memfrees=>38643, :mempauses=>53891, :memused=>2002, 
    :created_at=>"2021-03-30T18:54:01.757Z", :updated_at=>"2021-03-30T18:54:01.757Z"}
  ]

  Our threshold data : 
  <Threshold id: 8, name: "memused", min: 30000, max: 90000, created_at: "2021-03-29 21:28:02.989235000 +0000", updated_at: "2021-03-29 21:28:02.989235000 +0000">
  We need to compare and  if we have any corresponding range between min and max values, we will crate and alert

=end

class FindThresholdsAlertJob < ApplicationJob

  def perform(metrics)
    @sending_email_alert_ids = []
    @metrics = JSON.load(metrics)
    @thresholds = Threshold.get_all_threshold_from_cache
    start
    send_notifier_job
  end

  private

  def start

    keys = []
    @metrics.each do |mt|
      mt.each do |k,v|
        keys << k
      end
    end

    #By finding equal ones, it will behave more efficiently in the main loop.
    matches = @thresholds.all{|th| keys.include? th.name }
    return unless matches.present?

    @metrics.each do |metric|
      metric.each do |k,v|
        matches.each do |th|
          if k == th.name
            #If the metrics we have are out of the min and max ranges of the threshold, create an alert.
            if (th.min.present? and v < th.min) or (th.max.present? and th.max < v)
              alert = Alert.create!(threshold_id: th.id, metric: metric, status: Alert.status_open)
              if alert
                puts "Alert has been created: #{alert.to_json}"
              end
              unless @sending_email_alert_ids.include? alert.id
                @sending_email_alert_ids << alert.id
              end
            end
          end
        end
      end
    end
  end


  def send_notifier_job
    if @sending_email_alert_ids.present?
      #end the generated alert ids to the relevant email notifier.
      puts "We are sending alert ids to the email notifiers"
      unless Rails.env.test?
        ThresholdNotifierJob.set(queue: :alert_notifier).perform_now(JSON.dump(@sending_email_alert_ids))
      end
    end

    if Rails.env.test?
      return @sending_email_alert_ids
    end
  end

end
