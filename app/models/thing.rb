class Thing < ActiveRecord::Base
  belongs_to :user
  has_many :measurements

  before_create :set_api_key

  validates_inclusion_of :alarm_threshold, :in => 0..10
  validate :alarm_min_max

  def set_api_key
    require 'securerandom'
    # find a free api key (in case of collisions)
    while Thing.find_by_api_key(new_api_key = SecureRandom.urlsafe_base64(20))
    end
    # set the free api key to the new instance
    self.api_key = new_api_key
  end

  def reset_api_key!
    self.set_api_key
    save!
  end

  def alarm_min_max
    unless (self.alarm_min < self.alarm_max) or (self.alarm_min == 0 and self.alarm_max == 0)
      errors.add :alarm_min, "should be lower than the alarm maximum"
    end
  end

  def check_alarm
    # do not trigger alarm if alarm's action, threshold or range are not set (null or equal to 0)
    return if (self.alarm_action.blank?) or (not self.alarm_threshold) or (self.alarm_threshold == 0) or (self.alarm_min == self.alarm_max)
    # alarm is triggered by default, unless we tell not to
    trigger_alarm = true
    # grab X last measurements
    measurements = self.measurements.last(self.alarm_threshold)
    # check if all X last measurements are in range
    measurements.each do |measurement|
      # check if alarm is in range, if so disable the trigger and break the loop
      if measurement.value >= self.alarm_min and measurement.value <= self.alarm_max
        trigger_alarm = false
        break
      end
    end
    # check where to trigger
    if trigger_alarm
      # one measurement is enough, because we already know the alarm was not in normal range
      if measurements.last.value > self.alarm_max
        trigger_alarm = :high
      else
        trigger_alarm = :low
      end
    end
    # finish check and decide what to do
    if trigger_alarm
      self.trigger_alarm trigger_alarm
    else
      self.untrigger_alarm
    end
  end

  def trigger_alarm state
    # TODO: we will let the action control multiple notifications
    # # do not trigger alarm if has already been triggered (i.e. to avoid spamming)
    # return if self.alarm_triggered
    # TODO: .
    # else we change the state and execute its action
    Action.do(self, state)
    self.update alarm_triggered: true
  end

  def untrigger_alarm
    # TODO: we will let the action control multiple notifications
    # # do not untrigger if it's already untriggered
    # return unless self.alarm_triggered
    # TODO: .
    Action.do(self, :normal)
    self.update alarm_triggered: false
  end

end
