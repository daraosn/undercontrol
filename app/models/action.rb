require 'httparty'

class Action
  REQUEST_TIMEOUT = 5 # seconds

  # NOTE: to see changes reflected, sprockets cache must be cleared
  def self.types
    {
      http_get:      'HTTP GET',
      http_post:     'HTTP POST',
      send_email:    'Send Email',
      mqtt_actuator: 'MQTT Actuator',
    }
  end

  def self.change_state thing, state = :normal
    ###
    # TODO: WARNING: these action should not be done syncronously, it could block the webserver if takes too long!
    #                actions should be asyncronous and queued using Resque or a similar manager.
    ###

    json = thing.alarm_action
    action = JSON.parse json, object_class: OpenStruct
    action.state = state
    action.thing = thing
    action.value = thing.measurements.last.value

    self.do action
  end

  def self.abort action
    puts "#{Time.now.to_f * 1000} | ABORTED: Action: #{action.type}, by thing: #{action.thing.id}"
  end

  def self.do action
    puts "#{Time.now.to_f * 1000} | DO: Action: #{action.type}, by thing: #{action.thing.id}"

    case action.type.to_sym
    when :send_email
      self.do_email action
    when :http_get
      self.do_get_request action
    when :http_post
      self.do_post_request action
    when :mqtt_actuator
      self.do_mqtt_pub action
    when :test
      self.do_test action
    else
      raise "Undefined Action type: #{action.type}"
    end
  end

  def self.do_email action
    return abort action if action.state == :normal
    # TODO: later enable custom emails, for now we use user account's email (taken from thing.user)
    AlarmMailer.alarm_triggered(action.thing).deliver!
  end

  def self.do_get_request action
    return abort action unless check_url action.url
    url = inject_undercontrol_url_params action.url, action.value, action.state
    HTTParty.get(url, timeout: REQUEST_TIMEOUT).body
  end

  def self.do_post_request action
    return abort action unless check_url action.url
    body = inject_undercontrol_params "", action.value, action.state
    HTTParty.post(action.url, timeout: REQUEST_TIMEOUT, body: body).body
  end

  def self.do_mqtt_pub action
    MQTT::Client.connect(Rails.application.secrets.mqtt_server) do |c|
      # Important: when modifying `topic` below, remember to update `_alarm_actions` partial view
      topic = "states/" + action.thing.api_key
      c.publish(topic, { value: action.value, state: action.state }.to_json)
    end
  end

  def self.do_test action
    puts state: action.state 
  end

  def self.new_send_email email#, message=""
    { type: :send_email, email: email }.to_json
  end

  def self.new_http_get url
    { type: :http_get, url: url }.to_json
  end

  def self.new_http_get url#, body, headers=""
    { type: :http_post, url: url }.to_json
  end

  def self.new_mqtt_actuator
    { type: :mqtt_actuator, url: url }.to_json
  end

  private

  def self.check_url url
    (url =~ Regexp.new(Rails.application.secrets.domain_name, 'i')).blank?
  end

  def self.inject_undercontrol_url_params url, value, state
    uri =  URI.parse url
    uri.query = inject_undercontrol_params uri.query, value, state
    uri.to_s
  end

  def self.inject_undercontrol_params query_string, value, state
    query_string ||= ""
    our_params = undercontrol_params value, state, true
    their_params = URI.decode_www_form query_string
    URI.encode_www_form their_params + our_params
  end

  def self.undercontrol_params value, state, array=false
    hash = { undercontrol_value: value, undercontrol_state: state }
    return array ? hash.collect { |k,v| [k, v] } : hash
  end

end
