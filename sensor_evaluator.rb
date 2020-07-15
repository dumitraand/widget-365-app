require 'json'
require 'optparse'

Dir[File.join(__dir__, 'lib', '**', '*.rb')].each { |f| require f }

options = {
  file_path: File.join(__dir__, "docs", "sensors.log")
}

OptionParser.new do |opts|
  opts.banner = "Usage: example.rb [options]"

  opts.on("-f FILE", "--file=FILE", "Open file for reading") do |v|
    options[:file_path] = v
  end
end.parse!



class SensorEvaluator
  attr_accessor :data, :processor
  def initialize(data, processor: TextParser)
    @data = data
    @processor = processor.new(@data)
    @sensors = []
  end

  def parse
    @sensors = processor.parse!
  end

  def evaluate!
    parse
    JSON.pretty_generate(@sensors.map { |s| [s.name, s.evaluate!] }.to_h)
  end
end

data = File.read(options[:file_path])

print SensorEvaluator.new(data).evaluate!
