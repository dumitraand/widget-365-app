require_relative '../test_helper.rb'

class TextParserTest < Minitest::Test
  include TestHelper

  def setup
    @parser = TextParser.new("")
  end

  def test_is_reference
    reference_data = "reference 1 2 3".split(" ")
    assert_equal(@parser.is_reference?(reference_data), true)
  end

  def test_is_reference_wrong_line
    wrong_line = "wrongline"
    assert_equal(@parser.is_reference?(wrong_line), false)
    wrong_line = "wrongline"
    assert_equal(@parser.is_reference?([wrong_line]), false)
  end

  def test_is_label_humidity
    label_data = "humidity tag".split(" ")
    assert_equal(@parser.is_label?(label_data), true)
    label_data = "humidity"
    assert_equal(@parser.is_label?([label_data]), true)
  end

  def test_is_label_thermometer
    label_data = "thermometer tag".split(" ")
    assert_equal(@parser.is_label?(label_data), true)
    label_data = "thermometer"
    assert_equal(@parser.is_label?([label_data]), true)
  end

  def test_is_label_monoxide
    label_data = "monoxide tag".split(" ")
    assert_equal(@parser.is_label?(label_data), true)
    label_data = "monoxide"
    assert_equal(@parser.is_label?([label_data]), true)
  end

  def test_is_label_sensor_not_added
    label_data = "sensor_type tag".split(" ")
    assert_equal(@parser.is_label?(label_data), false)
    label_data = "sensor_type"
    assert_equal(@parser.is_label?([label_data]), false)
  end

  def test_is_label_wrong_line
    wrong_line = "wrongline"
    assert_equal(@parser.is_label?([wrong_line]), false)
    wrong_line = "wrongline"
    assert_equal(@parser.is_reference?(wrong_line), false)
  end

  def test_is_reading
    reading_data = "#{Time.now} 42.5".split(" ")
    assert_equal(@parser.is_reading?(reading_data), true)
  end

  def test_is_reading_without_metadata
    reading_data = "42.5"
    assert_equal(@parser.is_reading?([reading_data]), true)
  end

  def test_is_reding_just_metadata
    reading_data = "#{Time.now}"
    assert_equal(@parser.is_reading?([reading_data]), false)
  end

  def test_is_reading_ending_with_metadata
    reading_data = "Metadata 42.5 Some Other Metadata".split(" ")
    assert_equal(@parser.is_reading?(reading_data), false)
  end

  def test_is_reading_wrong_line
    wrong_line = "wrongline"
    assert_equal(@parser.is_reading?([wrong_line]), false)
    wrong_line = "wrongline"
    assert_equal(@parser.is_reading?(wrong_line), false)
  end

  def test_parse_should_return_nothing
    @parser = TextParser.new(read_test_file("test_1.log"))
    data = @parser.parse!
    assert_empty(data)
  end

  def test_parse_should_return_one_sensor_with_no_reference_value
    @parser = TextParser.new(read_test_file("test_2.log"))
    data = @parser.parse!
    assert_equal(data.count, 1)
    
    sensor = data.first
    assert_equal(sensor.class, Thermometer)
    assert_equal(sensor.name, "tag")
    assert_empty(sensor.readings)
    assert_equal(sensor.reference_value, 0.0)
  end

  def test_parse_should_return_two_sensors_with_one_reading_each
    @parser = TextParser.new(read_test_file("test_3.log"))
    data = @parser.parse!
    assert_equal(data.count, 2)
    
    sensor = data.first
    assert_equal(sensor.class, Thermometer)
    assert_equal(sensor.name, "tag")
    assert_equal(sensor.readings.count, 1)
    assert_equal(sensor.reference_value, 0.0)
    
    reading = sensor.readings.first
    assert_equal(reading.value, 10.2)

    sensor = data.last
    assert_equal(sensor.class, HumiditySensor)
    assert_equal(sensor.name, "tag2")
    assert_equal(sensor.readings.count, 1)
    assert_equal(sensor.reference_value, 0.0)

    reading = sensor.readings.first
    assert_equal(reading.value, 9.3)
  end

  def test_parse_should_just_take_first_reference_value
    @parser = TextParser.new(read_test_file("test_4.log"))
    data = @parser.parse!
    assert_equal(data.count, 1)
    
    sensor = data.first
    assert_equal(sensor.class, MonoxideSensor)
    assert_equal(sensor.name, "tag3")
    assert_equal(sensor.readings.count, 1)
    assert_equal(sensor.reference_value, 3.0)

    reading = sensor.readings.first
    assert_equal(reading.value, 5.0)
  end

  def test_parse_unknown_line
    @parser = TextParser.new(read_test_file("test_5.log"))
    assert_raises Parser::ParseError do
      @parser.parse!
    end
  end
end
