class Api::V1::MeasurementsController < ApplicationController

  def create
    unless params["value"].blank?
      # Heroku restriction
      count = Measurement.count
      heroku_limit = 6500 # supports 10000 but to avoid mails 6500
      if count > heroku_limit
        Measurement.order(:id).limit(count - heroku_limit).destroy_all
      end
      @measurement = Measurement.create value: params["value"]
      Pusher.trigger('measurements', 'new', @measurement.as_json)
    end
    render json: @measurement
  end

  def index
    render json: Measurement.all
    #render json: Measurement.where("strftime('%H', created_at) >= ?", Time.zone.now.hour)
    #render json: Measurement.where("HOUR(created_at) = ?", Time.zone.now.hour)
    #render json: Measurement.where("created_at >= ?", Time.zone.now.beginning_of_day)
  end

end
