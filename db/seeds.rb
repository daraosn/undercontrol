# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
user = CreateAdminService.new.call
puts 'CREATED ADMIN USER: ' << user.email
#CreatePlanService.new.call
#puts 'CREATED PLANS'


##Create Sensors

sensorKind=['Thermometer', 'Accelerometer', 'Claps', 'Light', 'Speed']
signalUnit=['Celsius', 'm/s^2', 'Claps', 'lumens', 'km/hr']
actuatorKind=['Relay', 'RGB Light', 'Heater', 'Speaker', 'Water Tap']
actionKind=['Set Value', 'Set State', 'Switch State', 'Increase Value', 'Decrease Value']

userId = 1

for i in 1..5
  sensor = UcSensor.create(:name => "Sensor #{i}", :kind => sensorKind[i-1], :user_id => userId)
  signal = UcSignal.create(:uc_sensor_id => "#{i}", :unit => signalUnit[i-1])
  actuator = UcActuator.create(:name => "Actuator #{i}", :kind => actuatorKind[i-1], :user_id => userId)
  process = UcProcess.create(:name => "Process #{i}", :user_id => userId)
  action = UcAction.create(:name => "Action #{i}", :kind => actionKind[i-1], :uc_process_id => "#{i}", )
  condition = UcCondition.create(:logic => "{}", :uc_process_id => "#{i}")
end

for i in 1..5
	for j in 1..200
  		measurement = UcMeasurement.create(:uc_signal_id => "#{i}", :value => rand(20..40))
  	end
end

