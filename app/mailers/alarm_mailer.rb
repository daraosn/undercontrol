class AlarmMailer < ApplicationMailer
  def alarm_triggered(thing)
    @thing = thing
    mail(to: thing.user.email, subject: "Alarm triggered: #{thing.name}")
  end
end
