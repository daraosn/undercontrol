class Api::V1::MeasurementsController < ApplicationController

  def create
    unless params["value"].blank?
      @measurement = Measurement.create value: params["value"]
    end
    render json: @measurement
  end

  def index
    render json: Measurement.all
  end

end
