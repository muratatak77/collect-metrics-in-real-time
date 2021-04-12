class ThresholdNotifier < ApplicationMailer

=begin
  Html page
  Views / threshold_notifier / new_alert.html.erb  
=end

  def new_alert(alert_id)
    @alert_id = alert_id
    puts "Alert in ThresholdNotifier. We will send an email using by alert id: #{@alert_id}"
    if mail(:to => ENV.fetch("SENDING_EMAIL_TO"), :subject => get_subject)
      puts "We are sending an email. Alert : #{alert_id}"
    end
  end

  private

  def get_subject
    "You have new alert_id in your metrics. Date - Time : #{DateTime.now.utc}"
  end

end
