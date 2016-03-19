class ApplicationMailer < ActionMailer::Base
  default :from => "#{Rails.application.secrets.site_name} <#{Rails.application.secrets.noreply_email}>"
  layout 'mailer'
end
