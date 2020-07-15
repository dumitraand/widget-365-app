require_relative '../reading.rb'

class Sensor
  class EvaluationMethodNotDefined < StandardError; end

  attr_reader :readings, :reference_value, :name
  def initialize(readings: [], name: nil, reference_value: 0.0)
    @readings = readings || []
    @name = name
    @reference_value = reference_value || 0.0
  end

  def add_reading(reading_value, metadata = {})
    @readings << Reading.new(reading_value, metadata)
  end

  def filtered_readings(filters: [])
    @readings.select do |reading|
      filters.map do |filter|
        reading.filter(filter)
      end.flatten.all?
    end
  end

  def reading_values(filters: [])
    filtered_readings(filters: filters).map(&:value)
  end

  def evaluate!
    raise EvaluationMethodNotDefined, "evaluate! is not implemented in #{self.class}"
  end
end
