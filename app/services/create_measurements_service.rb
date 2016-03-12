class CreateMeasurementsService
  def self.make
    Thing.all.each do |thing|
      for j in 1..200
          measurement = Measurement.create(
            value: rand(20..40),
            created_at: Time.now + j.seconds
          )
          thing.measurements << measurement
        end
    end
  end
end