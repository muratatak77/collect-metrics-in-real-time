class ThresholdNotifierJob < ApplicationJob

  def perform(alert_ids)
    @alert_ids = JSON.load(alert_ids)
    puts "We got alert_ids : #{@alert_ids}"
    start
  end

  private

  def start
    @alert_ids.each do |alert_id|
      puts "We will sending an email for the alert : #{alert_id}"
      ThresholdNotifier.new_alert(alert_id).deliver_now
    end
  end

end
