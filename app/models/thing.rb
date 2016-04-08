class Thing < ActiveRecord::Base
  belongs_to :user
  has_many :measurements

  before_create :reset_api_key!

  has_one :api_key

  validates_inclusion_of :alarm_threshold, :in => 0..10
  validate :alarm_min_max

  def check_alarm
    # do not trigger alarm if alarm's action, threshold or range are invalid
    return false if (self.alarm_action.blank?) or (self.alarm_threshold == 0) or (self.alarm_min >= self.alarm_max)

    # grab X last measurements
    measurements = self.measurements.last(self.alarm_threshold)
    # check if all X last measurements are in range
    measurements.map! do |measurement|
      value = measurement.value
      if value > self.alarm_max
        :high
      elsif value < self.alarm_min
        :low
      else
        :normal
      end
    end

    if measurements.uniq.length == 1
      update_state measurements.last
    end
  end

  def update_state state
    if (state == :normal and alarm_triggered) or (state != :normal and not alarm_triggered)
      # Important: state must be updated first to avoid racing conditions and multiple action triggering
      self.update alarm_triggered: state != :normal
      Action.change_state(self, state)
    end
  end

  ###
  # Callbacks
  ###

  def reset_api_key!
    self.api_key.delete if self.api_key
    self.api_key = ApiKey.create!.generate_key!
    self.save!
  end

  ###
  # Validations
  ###

  def alarm_min_max
    unless (self.alarm_min < self.alarm_max) or (self.alarm_min == 0 and self.alarm_max == 0)
      errors.add :alarm_min, "should be lower than the alarm maximum"
    end
  end

end
