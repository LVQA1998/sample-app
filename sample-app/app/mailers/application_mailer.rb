class ApplicationMailer < ActionMailer::Base
  default from: Settings.norep_email
  layout "mailer"
end
