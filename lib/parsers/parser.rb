require 'date'
Dir[File.join('..', 'sensors', '*.rb')].each { |f| require f }

class Parser
  class ParserNotImplemented < StandardError; end
  class ParseError < StandardError; end

  SENSORS = {
    thermometer: Thermometer,
    humidity: HumiditySensor,
    monoxide: MonoxideSensor
  }

  attr_accessor :data
  def initialize(data)
    @data = data
  end

  def parse!
    raise ParserNotImplemented, "parse was not implemented by #{self.class}"
  end
end
