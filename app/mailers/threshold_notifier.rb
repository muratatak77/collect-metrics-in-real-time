class ThresholdNotifier < ActionMailer::Base
  default :from => Env.fetch("SMTP_NO_REPLY")


  def new_alerts(args={})

    order_email_prepare(user_id, order_id, is_update)

  end


  

end