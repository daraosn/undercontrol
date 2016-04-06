class Api::V1::ThingsController < ApplicationController
  before_filter :authenticate_user!, except: :add_measurement

  ###
  # external api
  ###

  def add_measurement
    value = params[:value]
    api_key = params[:api_key]

    thing = Thing.find_by_api_key api_key
    unless thing.blank? or value.blank?
      measurement = Measurement.new value: value
      thing.measurements << measurement
      measurement.save!
      if measurement.persisted?
        Pusher.trigger("things-#{thing.id}-measurements", 'new', measurement.as_json) rescue false
        return render json: { success: true, errors: [] }
      end
    else
      return render json: { success: false, errors: ['Invalid parameters'] }, status: :not_found
    end
    render json: { success: false, errors: ['Unable to add measurement'] }
  end

  ###
  # internal api
  ###

  def index
    render json: current_user.things
  end

  def create
    thing = Thing.new(name: 'New Thing', alarm_threshold: 0, alarm_action: Action.new_send_email(current_user.email))
    current_user.things << thing
    thing.save!
    render json: thing
  end

  def destroy
    @thing = current_user.things.find(params[:id])
    if @thing.present?
      @thing.destroy
    end
    head :ok
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
    interval = params[:interval] or :day
    conditions = get_range_condition params[:range]
    # puts '(1) memory_usage: ' + `ps -o rss= -p #{$$}`
    @measurements = current_user.things.find(thing_id).measurements.select(fields).where(conditions)
    # limit number of results
    count = @measurements.count(:all)
    max = 1000
    if count > max
      @measurements = @measurements.to_a.shuffle.select.each_with_index do |_,i|
        i % (count / max) == 0
      end
    end
    # puts '(2) memory_usage: ' + `ps -o rss= -p #{$$}`
    respond_to do |format|
      format.json {
        render json: @measurements.as_json(only: fields) # Oj.dump(@measurements, mode: :compat)
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

  def get_range_condition range
    range ||= :day
    range = range.to_sym
    date = Time.now
    case range
    when :year
      date -= 1.year
    when :month
      date -= 1.month
    when :week
      date -= 1.week
    when :hour
      date -= 1.hour
    else # :day is default
      date -= 1.day
    end
    ['created_at >= ?', date]
  end

end
