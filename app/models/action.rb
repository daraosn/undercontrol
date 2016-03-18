class Action
  def self.do json
    action = JSON.parse json, symbolize_names: true
    type = action[:type].to_sym
    case type
    when :email
      email= action[:email]
      puts "TODO: action: send email to #{email}"
    when :http_get
      url = action[:url]
      puts "TODO: action: http get to #{url}"
    when :http_post
      url = action[:url]
      body = action[:body]
      puts "TODO: action: http post to #{url} with body #{body}"
    else
      raise "Undefined Action type: #{type}"
    end
  end

  def self.new_send_email email
    { type: :email, email: email }.to_json
  end

  def self.new_http_get url
    { type: :http_get, url: url }.to_json
  end

  def self.new_http_get url, body
    { type: :http_post, url: url, body: body }.to_json
  end

end
