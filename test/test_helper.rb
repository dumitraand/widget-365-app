require 'minitest/autorun'
require 'pry'
Dir[File.join(File.expand_path(Dir.pwd), "lib", "**", "*.rb")].each { |f| require f }

module TestHelper
  def read_test_file(file_name)
    File.read(File.join(__dir__, "fixtures", file_name))
  end
end
