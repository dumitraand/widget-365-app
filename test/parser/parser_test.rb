require_relative '../test_helper.rb'

class ParserTest < Minitest::Test
  def setup
    @parser = Parser.new("")
  end

  def test_sensors_naming
    assert_equal(Parser::SENSORS.keys, [:thermometer, :humidity, :monoxide])
  end

  def test_sensors_classes
    assert_equal(Parser::SENSORS.values, [Thermometer, HumiditySensor, MonoxideSensor])
  end

  def test_data
    assert_equal(@parser.data, "")
  end

  def test_parse_method
    assert_raises Parser::ParserNotImplemented do
      @parser.parse!
    end
  end
end
