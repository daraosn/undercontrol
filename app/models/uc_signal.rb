class UcSignal < ActiveRecord::Base
  belongs_to :uc_sensor
  has_many :uc_measurements

  has_many :uc_signals_monitors
  has_many :uc_monitors, through: :uc_signals_monitors

  has_many :uc_conditions_signals
  has_many :uc_conditions, through: :uc_conditions_signals

  validates :unit, presence: true
  validates_associated :uc_sensor
end
