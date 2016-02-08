# config/initializers/pusher.rb
require 'pusher'

Pusher.url = "https://b35a4fcab94f68f53468:ec514fbdcc1b4908ce89@api.pusherapp.com/apps/176827"
Pusher.logger = Rails.logger

# app/controllers/hello_world_controller.rb
class HelloWorldController < ApplicationController
  def hello_world
    Pusher.trigger('test_channel', 'my_event', {
      message: 'hello world'
    })
  end
end