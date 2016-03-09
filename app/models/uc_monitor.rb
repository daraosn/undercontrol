class UcMonitor < ActiveRecord::Base
  belongs_to :user

  has_many :uc_signals_monitors
  has_many :uc_signals, through: :uc_signals_monitors
end
