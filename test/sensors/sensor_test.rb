require_relative '../test_helper.rb'

class SensorTest < Minitest::Test
  def setup
    @sensor = Sensor.new
  end

  def test_default_values
    assert_nil(@sensor.name)
    assert_equal(@sensor.reference_value, 0.0)
    assert_empty(@sensor.readings)
  end

  def test_with_set_values
    readings = Array.new(3) { Reading.new(value: rand(0.0..10.0), metadata: {}) }
    sensor = Sensor.new(
      readings: readings,
      name: "test-name",
      reference_value: 10.0
    )

    assert_equal(sensor.readings, readings)
    assert_equal(sensor.name, "test-name")
    assert_equal(sensor.reference_value, 10.0)
  end

  def test_with_nils
    sensor = Sensor.new(readings: nil, name: nil, reference_value: nil)
    assert_nil(sensor.name)
    assert_equal(sensor.reference_value, 0.0)
    assert_empty(sensor.readings)
  end

  def test_add_readings
    assert_empty(@sensor.readings)

    10.times do |i|
      @sensor.add_reading(i, { label: "label-#{i}" })
    end

    assert_equal(@sensor.readings.map(&:value), (0..9).to_a)
    assert_equal(@sensor.readings.map(&:metadata), Array.new(10) { |i| { label: "label-#{i}" }})
  end

  def test_filtered_readings
    10.times do |i|
      @sensor.add_reading(i, { label: i })
    end

    filter = Filter.new(:label, :<, 5)
    assert_equal(
      @sensor.filtered_readings(filters: [filter]),
      @sensor.readings[0..4]
    )
  end

  def test_reading_values_without_filter
    10.times do |i|
      @sensor.add_reading(i, { label: i })
    end

    assert_equal(@sensor.reading_values, (0..9).to_a)
  end

  def test_reading_values_with_filter
    10.times do |i|
      @sensor.add_reading(i, { label: i })
    end

    filter = Filter.new(:label, :<, 5)
    assert_equal(@sensor.reading_values(filters: [filter]), (0..4).to_a)
  end


  def test_evalute
    assert_raises Sensor::EvaluationMethodNotDefined do
      @sensor.evaluate!
    end
  end
end
