class Measurement < ActiveRecord::Base
  belongs_to :thing

  after_create :check_alarm

  def check_alarm
    self.thing.check_alarm
  end

end
