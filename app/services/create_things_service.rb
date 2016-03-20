class CreateThingsService
  def self.make user
    for i in 1..5
      thing = Thing.new(
        name: "Sensor #{i}",
        description: "Description #{i}",
        range_min: 20,
        range_max: 40,
        alarm_min: rand(20..25),
        alarm_max: rand(35..40),
        alarm_threshold: 0, # WARNING: DO NOT ENABLE THIS, OR TOO MANY EMAILS WILL BE SENT WHEN SEEDING
        alarm_action: Action.new_send_email("test.ucio@yopmail.com")
      )
      user.things << thing
      thing.save!
    end
  end
end