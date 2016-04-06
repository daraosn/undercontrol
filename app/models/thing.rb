class Thing < ActiveRecord::Base
  belongs_to :user
  has_many :measurements

  before_create :set_api_key

  validates_inclusion_of :alarm_threshold, :in => 0..10
  validate :alarm_min_max

  def reset_api_key!
    self.set_api_key
    save!
  end

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

  def set_api_key
    require 'securerandom'
    # find a free api key (in case of collisions)
    while Thing.find_by_api_key(new_api_key = SecureRandom.urlsafe_base64(20))
    end
    # set the free api key to the new instance
    self.api_key = new_api_key
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
