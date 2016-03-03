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
    fields = [:created_at, :value]
    @measurements = Measurement.all.select(fields)
    respond_to do |format|
      format.json {
        render json: @measurements
      }
      format.csv {
        render text: create_csv(@measurements, fields)
      }
    end
    #render json: Measurement.where("strftime('%H', created_at) >= ?", Time.zone.now.hour)
    #render json: Measurement.where("HOUR(created_at) = ?", Time.zone.now.hour)
    #render json: Measurement.where("created_at >= ?", Time.zone.now.beginning_of_day)
  end

  private
  def create_csv data, fields, separator = ','
    csv = fields.join(separator) + "\n"
    data.each do |value|
      line = []
      fields.each do |field|
        escaped_value = value[field].to_s.gsub('"', '\"')
        line << "#{escaped_value}"
      end
      csv += line.join(separator) + "\n"
    end
    csv
  end

end
