class ApplicationMailer < ActionMailer::Base
  default from: Settings[:email_from]
  layout 'mailer'
end
