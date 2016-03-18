require 'httparty'

class Action
  REQUEST_TIMEOUT = 5 # seconds

  def self.types
    {
      http_get:   'HTTP GET',
      http_post:  'HTTP POST',
      send_email: 'Send Email'
    }
  end
  
  def self.do thing
    ###
    # TODO: SUPER IMPORTANT WARNING!
    # If an HTTP GET or HTTP POST is configured to the same Thing that trigger the alarm,
    # it will create an infinite loop, avoid this by checking if the URL contains the api_key.
    # If so, then do not excecute the call. Add a check+test before creating the alarm too.
    ###

    # TODO: WARNING: these action should not be done syncronously, it could block the webserver if takes too long!
    #                actions should be asyncronous and queued using Resque or a similar manager.

    json = thing.alarm_action
    action = JSON.parse json, symbolize_names: true
    type = action[:type].to_sym

    # KEEP FOR DEBUG:
    puts "#{Time.now.to_f * 1000} | Action: #{type}, by thing: #{thing.id}"
    
    case type
    when :send_email
      # TODO: later enable custom emails, for now we use user account's email (taken from thing.user)
      #email = action[:email]
      AlarmMailer.alarm_triggered(thing).deliver!
    when :http_get
      self.do_get_request action
    when :http_post
      self.do_post_request action
    else
      raise "Undefined Action type: #{type}"
    end
  end

  def self.new_send_email email, message=""
    { type: :send_email, email: email, message: message }.to_json
  end

  def self.new_http_get url, headers=""
    { type: :http_get, url: url, headers: headers }.to_json
  end

  def self.new_http_get url, body, headers=""
    { type: :http_post, url: url, body: body, headers: headers }.to_json
  end

  def self.do_get_request action
    puts 'GET request to url: ' + action[:url]
    HTTParty.get(action[:url], timeout: REQUEST_TIMEOUT).body#, headers: action[:headers]).body
    puts 'GET request done!'
  end

  def self.do_post_request action
    HTTParty.post(action[:url], timeout: REQUEST_TIMEOUT, body: action[:body]).body#, headers: action[:headers]).body
  end
end
