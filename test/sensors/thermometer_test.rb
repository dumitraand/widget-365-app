require_relative '../test_helper.rb'

class ThermometerTest < Minitest::Test
  def setup
    @sensor = Thermometer.new(name: "test")
  end

  def test_evaluate_no_data
    assert_equal(@sensor.evaluate!, "no data")
  end

  def test_ultra_precise
    @sensor.add_reading(0.3)
    assert_equal(@sensor.evaluate!, "ultra precise")
  end

  def test_ultra_precise_multiple_readings
    Array.new(10) { rand(0.0..0.5) }.each do |v|
      @sensor.add_reading(v)
    end
    assert_equal(@sensor.evaluate!, "ultra precise")
  end

  def test_ultra_precise_multiple_readings_and_reference_value
    @sensor = Thermometer.new(name: "test-2", reference_value: 10)

    Array.new(10) { rand(9.5..10.5) }.each do |v|
      @sensor.add_reading(v)
    end
    assert_equal(@sensor.evaluate!, "ultra precise")
  end

  def test_very_precise
    @sensor.add_reading(-4.2)
    @sensor.add_reading(3.4)
    assert_equal(@sensor.evaluate!, "very precise")
  end

  def test_very_precise_with_reference_value
    @sensor = Thermometer.new(name: "test-2", reference_value: 10)
    @sensor.add_reading(6.3)
    @sensor.add_reading(14.1) # standard deviation > 3 but < 5 (~ 3.9)

    assert_equal(@sensor.evaluate!, "very precise")
  end

  def test_precise_by_average
    @sensor.add_reading(-0.6)
    assert_equal(@sensor.evaluate!, "precise")
  end

  def test_precise_with_standard_deviation
    @sensor.add_reading(-8.4)
    @sensor.add_reading(9.2)
    assert_equal(@sensor.evaluate!, "precise")
  end

  def test_precise_by_averge_with_reference_value
    @sensor = Thermometer.new(name: "test-2", reference_value: 10)
    @sensor.add_reading([9.3, 11.7].sample)
    assert_equal(@sensor.evaluate!, "precise")
  end

  def test_precise_by_standard_deviation_with_reference_value
    @sensor = Thermometer.new(name: "test-2", reference_value: 10)
    @sensor.add_reading(1.73)
    @sensor.add_reading(19.2)
    assert_equal(@sensor.evaluate!, "precise")
  end
end
