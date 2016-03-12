class Thing < ActiveRecord::Base
  belongs_to :user
  has_many :measurements
end
