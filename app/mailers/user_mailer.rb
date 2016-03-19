class UserMailer < ApplicationMailer
  def expire_email(user)
    mail(:to => user.email, :subject => "Subscription Cancelled")
  end
end
