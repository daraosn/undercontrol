Undercontrol
================

Open Source realtime Internet of Things Platform with MQTT and Web-sockets support.


Problems? Issues?
-----------

Please open a Github issue or contact me at diego@undercontrol.io

Ruby on Rails
-------------

This application requires:

- Ruby 2.3.0
- Rails 4.2.5.1
- MySQL Server
- MQTT Server

MQTT
----

You can use Mosquito or your own implementation. Undercontrol is currently using a node service, if you feel lazy you can my implementation at `mqtt.undercontrol.io`,

```node
var mosca = require('mosca')
var request = require('request');
var undercontrolApiUrl = "http://localhost:3000/api/v1/things/measurements?api_key=:api_key&value=:value";

var ascoltatore = {
  type: 'redis',
  redis: require('redis'),
  db: 12,
  port: 6379,
  return_buffers: true, // to handle binary payloads
  host: "localhost"
};

var moscaSettings = {
  port: 1883,
  backend: ascoltatore,
  persistence: {
    factory: mosca.persistence.Redis
  }
};

var server = new mosca.Server(moscaSettings);
server.on('ready', setup);

server.on('clientConnected', function(client) {
  console.log('client connected', client.id);
});

// fired when a message is received
server.on('published', function(packet, client) {
  console.log('Published', packet.topic, packet.payload);
  var apiKeyRegex = /sensors\/([A-Za-z0-9-_]+)/
  var apiKeyMatch = packet.topic.match(apiKeyRegex);
  if(apiKeyMatch != null) {
    var apiKey = apiKeyMatch[1];
    var apiUrl = undercontrolApiUrl.replace(':api_key', apiKey).replace(':value', packet.payload.toString());
    request.get(apiUrl, function (error, response, body) {
      if (!error && response.statusCode == 200) {
        console.log(body);
      } else {
        console.error("Invalid response from API URL:", apiUrl, error);
      }
    });
  } else {
    console.log("Invalid topic format:", packet.topic);
  }
});

// fired when the mqtt server is ready
function setup() {
  console.log('Mosca server is up and running')
}
```

Author
------

Diego Araos <diego@undercontrol.io>

Contributors
------------

Rodolfo del Valle <rodolfo@undercontrol.io>

MIT License
-----------

Copyright (c) 2016 Diego Araos <diego@undercontrol.io> <d@wehack.it>

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
