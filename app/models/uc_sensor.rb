class UcSensor < ActiveRecord::Base
  has_many :uc_signals
  belongs_to :user

  validates :name, :kind, presence: true
  validates_associated :user
end
