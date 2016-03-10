class UcMeasurement < ActiveRecord::Base
  belongs_to :uc_signal
  validates_associated :uc_signal
end
