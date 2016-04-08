class ApiKey < ActiveRecord::Base
  belongs_to :thing

  def generate_key!
    require 'securerandom'
    # find a free api key (in case of collisions)
    while ApiKey.find_by_key(new_api_key = SecureRandom.urlsafe_base64(20))
    end
    # set the free api key to the new instance
    self.key = new_api_key
  end
end
