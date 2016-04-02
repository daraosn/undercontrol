module ApplicationHelper
  def home_url
    Rails.application.secrets.home_url or 'http://undercontrol.io/'
  end
end
