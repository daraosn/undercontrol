class Api::V1::ThingsController < ApplicationController
  before_filter :authenticate_user!, except: :add_measurement

  # @public api
  def add_measurement
    value = params[:value]
    api_key = params[:api_key]

    thing = Thing.find_by_api_key api_key
    unless thing.blank? or value.blank?
      measurement = Measurement.new value: value
      thing.measurements << measurement
      measurement.save!
      if measurement.persisted?
        Pusher.trigger("things-#{thing.id}-measurements", 'new', measurement.as_json)
        return render json: { success: true, errors: [] }
      end
    else
      return render json: { success: false, errors: ['Invalid parameters'] }, status: :not_found
    end
    render json: { success: false, errors: ['Unable to add measurement'] }
  end

  ######

  def index
    render json: current_user.things
  end

  def create
    thing = Thing.new(name: 'New Thing')
    current_user.things << thing
    thing.save!
    render json: thing
  end

  def destroy
    @thing = Thing.find(params[:id])
    if @thing.present?
      @thing.destroy
    end
  render json: current_user.things
  end

  def update
    thing_params = params[:thing]
    if thing = current_user.things.find(thing_params[:id])
      thing.update thing_params.permit(:name, :description, :range_min, :range_max, :alarm_action, :alarm_min, :alarm_max, :alarm_threshold)
    end
    render json: thing
  end

  def reset_api_key
    thing = current_user.things.find_by_api_key(params[:api_key])
    unless thing.blank?
      thing.reset_api_key!
      render json: thing
    else
      render json: {}, status: :not_found
    end
  end

  def get_measurements
    thing_id = params[:thing_id]
    fields = [:created_at, :value]
    @measurements = current_user.things.find(thing_id).measurements.select(fields)
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
