require_relative '../test_helper.rb'

class HumidityTest < Minitest::Test
  def setup
    @sensor = HumiditySensor.new(name: "test")
  end

  def test_evaluate_no_data
    assert_equal(@sensor.evaluate!, "no data")
  end

  def test_discard_no_reference_value
    (1..5).to_a.sample.times do |i|
      @sensor.add_reading("0.#{i}".to_f)
    end

    @sensor.add_reading(2.0)
    assert_equal(@sensor.evaluate!, "discard")
  end

  def test_discard_with_reference_value
    @sensor = HumiditySensor.new(name: "test-2", reference_value: 45.0)
    (1..5).to_a.sample.times do |i|
      @sensor.add_reading(45.0 + "0.#{i}".to_f)
    end

    @sensor.add_reading([43.0, 46.1].sample)
    assert_equal(@sensor.evaluate!, "discard")
  end

  def test_keep_without_reference_value
    10.times do |i|
      @sensor.add_reading(i.to_f/10.to_f)
    end
    assert_equal(@sensor.evaluate!, "keep")
  end

  def test_keep_with_reference_value
    @sensor = HumiditySensor.new(name: "test-2", reference_value: 45.0)
    10.times do |i|
      @sensor.add_reading(45.0 - i.to_f/10.to_f)
      @sensor.add_reading(45.0 + i.to_f/10.to_f)
    end
    assert_equal(@sensor.evaluate!, "keep")
  end
end
