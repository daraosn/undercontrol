class Api::V1::MeasurementsController < ApplicationController

  def create
    unless params["value"].blank?
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
