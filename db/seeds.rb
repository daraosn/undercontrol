user = CreateAdminUserService.make
puts 'CREATED ADMIN USER: ' << user.email

#CreatePlanService.make
#puts 'CREATED PLANS'

CreateThingsService.make user
puts "CREATED #{Thing.count} THINGS"

CreateMeasurementsService.make
puts "CREATE #{Measurement.count} MEASUREMENTS"
