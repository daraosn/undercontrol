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

    if current_user.things.find(thing_id).blank?
      return head :not_found
    else
      # old, slow query:
      #@measurements = Thing.find(thing_id).measurements.select(fields).where(conditions)

      # TODO: IMPORTANT: clean up and move to model! (fat controller)
      # new query:
      fields = [:created_at, :value]
      measurements = []
      if last_measurement = Thing.find(thing_id).measurements.last
        sql_range = get_range_condition params[:range], last_measurement.created_at

        sql_fields = fields.blank? ? '*' : '`' + fields.join('`, `') + '`' 
        sql_query = sql_sanitize ["SELECT #{sql_fields} FROM measurements WHERE thing_id = ?", thing_id]
        sql_query+= " AND " + sql_sanitize(sql_range)
        measurements = ActiveRecord::Base.connection.execute sql_query
        measurements = reduce_array measurements.to_a, 1000
      end
    end

    respond_to do |format|
      format.json {
        render json: measurements.as_json(only: fields) # Oj.dump(measurements, mode: :compat)
      }
      format.csv {
        render text: array_to_csv(measurements, fields)
      }
    end
  end

  private
  def hash_to_csv data, fields, separator = ','
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

  def array_to_csv array, fields = false, separator = ','
    csv = ""
    csv += fields.to_csv unless fields.blank?
    array.each do |line|
      csv += line.to_csv
    end
    csv
  end

  def get_range_condition range, date = Time.now
    range ||= :day
    range = range.to_sym
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

  def reduce_array data, limit
    count = data.count
    return data if count <= limit
    result = []
    if count > 0 and limit > 0
      step = count / limit
      indexes = (0..count-1).step(step).to_a
      indexes.each { |i| result << data[i] }
    end
    result
  end

  def sql_sanitize array_sql_values
    ActiveRecord::Base.send :sanitize_sql_array, array_sql_values
  end

end
