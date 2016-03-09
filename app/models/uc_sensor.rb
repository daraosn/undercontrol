class UcSensor < ActiveRecord::Base
  has_many :uc_signals
  belongs_to :user
end
