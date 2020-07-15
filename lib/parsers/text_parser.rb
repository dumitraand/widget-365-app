require_relative 'parser.rb'
require 'pry'

class TextParser < Parser
  def initialize(data)
    super(data)
    @sensors = []
  end

  def parse!
    @data.split("\n").each do |line|
      line_data = line.split(" ")
      line_data = [line_data] unless line_data.is_a?(Array)

      if is_reference?(line_data)
        @reference ||= {
          thermometer: line_data[1].to_f,
          humidity: line_data[2].to_f,
          monoxide: line_data[3].to_f
        }
      elsif is_label?(line_data)
        sensor_type = line_data.first.downcase.to_sym
        @sensors << SENSORS[sensor_type].new(name: line_data.last, reference_value: @reference&.fetch(sensor_type, 0.0))
      elsif is_reading?(line_data)
        metadata = {
          timestamp: DateTime.parse(line_data.first)
        }
        @sensors.last.add_reading(line_data.last.to_f, metadata)
      else
        raise ParseError, "line #{line} could not be parsed"
      end
    end

    @sensors
  end

  def is_reference?(line_data)
    return false unless line_data.is_a?(Array)
    line_data.first == "reference"
  end

  def is_label?(line_data)
    return false unless line_data.is_a?(Array)
    SENSORS.keys.map(&:to_s).map(&:downcase).include?(line_data.first.downcase)
  end

  def is_reading?(line_data)
    return false unless line_data.is_a?(Array)
    !!/^[0-9\.]+$/.match(line_data.last)
  end
end
