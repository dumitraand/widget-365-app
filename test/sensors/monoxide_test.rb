require_relative '../test_helper.rb'

class MonoxideTest < Minitest::Test
  def setup
    @sensor = MonoxideSensor.new(name: "test")
  end

  def test_evaluate_no_data
    assert_equal(@sensor.evaluate!, "no data")
  end

  def test_discard_no_reference_value
    (1..3).to_a.sample.times do |i|
      @sensor.add_reading(i)
    end
    @sensor.add_reading(4.0)
    assert_equal(@sensor.evaluate!, "discard")
  end

  def test_discard_with_reference_value
    @sensor = MonoxideSensor.new(name: "test-2", reference_value: 6)
    (1..3).to_a.sample.times do |i|
      @sensor.add_reading(6 + i)
    end

    @sensor.add_reading(10)
    assert_equal(@sensor.evaluate!, "discard")
  end

  def test_keep_with_no_reference_value
    3.times do |i|
      @sensor.add_reading(i)
    end

    assert_equal(@sensor.evaluate!, "keep")
  end

  def test_keep_with_reference_value
    @sensor = MonoxideSensor.new(name: "test-2", reference_value: 6)
    3.times do |i|
      @sensor.add_reading(6 + i)
      @sensor.add_reading(6 - i)
    end

    assert_equal(@sensor.evaluate!, "keep")
  end
end
