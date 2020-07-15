require File.join(__dir__, "sensor.rb")

class Thermometer < Sensor
  def initialize(readings: [], name: nil, reference_value: 0.0)
    super(readings: readings, name: name, reference_value: reference_value)
  end

  def evaluate!
    return 'no data' if reading_values.empty?

    avg = reading_values.sum / reading_values.length
    sd = Math.sqrt(reading_values.map { |rv| (rv - avg)**2 }.sum / reading_values.length)

    if (avg - reference_value).abs < 0.5
      if sd > 5
        return 'precise'
      elsif sd < 5 && sd > 3
        return 'very precise'
      end
      'ultra precise'
    else
      'precise'
    end
  end
end
