class ApplicationMailer < ActionMailer::Base
  default :from => ENV.fetch("SMTP_NO_REPLY")
  layout 'mailer'
end
