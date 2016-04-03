module ApplicationHelper
  def home_url
    Rails.application.secrets.home_url or 'http://undercontrol.io/'
  end

  def mqtt_server
    Rails.application.secrets.mqtt_server
  end
end
