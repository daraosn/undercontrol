class UcSignalsMonitor < ActiveRecord::Base
  belongs_to :uc_signal
  belongs_to :uc_monitor
end

