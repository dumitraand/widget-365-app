require File.join(__dir__, "sensor.rb")

class MonoxideSensor < Sensor
  def initialize(readings: [], name: nil, reference_value: 0.0)
    super(readings: readings, name: name, reference_value: reference_value)
  end

  def evaluate!
    return 'no data' if reading_values.empty?
    
    reading_values.each do |value|
      return 'discard' if (value - reference_value).abs > 3
    end
    'keep'
  end
end
