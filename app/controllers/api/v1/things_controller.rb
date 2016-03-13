class Api::V1::ThingsController < ApplicationController

  def index
    # TODO: IMPORTANT: select current_user's things only!
    render json: Thing.all#.select(:id, :name, :description, :api_key) # TODO: filter later for security reasons
  end

  def create
    # TODO: create new thing
  end

  def update
    ## TODO: specify safe params to avoid mass injection
    ## TODO: Thing.update params[:thing]
    render json: {}
  end

  def reset_api_key
    # TODO: IMPORTANT: check current user has privileges
    thing = Thing.select(:api_key).find(params[:thing_id])
    unless thing.blank?
      thing.reset_api_key!
      render json: thing
    else
      render json: {}, status: :not_found
    end
  end

  def add_measurement
    thing_id = params[:thing_id]
    value = params[:value]

    thing = Thing.find thing_id
    unless thing.blank? or value.blank?
      measurement = Measurement.new value: value
      #TODO: check API key
      thing.measurements << measurement
      measurement.save!
      if measurement.persisted?
        Pusher.trigger("things-#{thing_id}-measurements", 'new', measurement.as_json)
      end
    end
    render json: measurement
  end

  def get_measurements
    thing_id = params[:thing_id]
    fields = [:created_at, :value]
    @measurements = Thing.find(thing_id).measurements.select(fields)
    respond_to do |format|
      format.json {
        render json: @measurements.as_json(only: fields)
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
