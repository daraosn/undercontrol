class Thing < ActiveRecord::Base
  belongs_to :user
  has_many :measurements

  before_create :set_api_key
  
  def set_api_key
    require 'securerandom'
    while Thing.find_by_api_key(new_api_key = SecureRandom.urlsafe_base64(20))
    end
    self.api_key = new_api_key
  end

  def reset_api_key!
    self.set_api_key
    save!
  end
end
