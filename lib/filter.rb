class Filter
  attr_accessor :key, :op, :value
  def initialize(key, op, value)
    @key = key
    @op = op
    @value = value
  end
end
