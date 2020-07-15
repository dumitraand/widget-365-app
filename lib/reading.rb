class Reading
  class FilterError < StandardError; end

  attr_reader :value, :metadata
  def initialize(value, metadata = {})
    @value = value
    @metadata = metadata
  end

  def filter(filter)
    if filter.key && filter.op && filter.value && @metadata[filter.key].respond_to?(filter.op)
      classes = [TrueClass, FalseClass]
      result = @metadata[filter.key].send(filter.op, filter.value)
      if classes.include?(result.class)
        result
      else
        raise FilterError, "filter did not return true or false"
      end
    else
      raise FilterError, "filter not properly configured or metadata from key does not respond to the operator"
    end
  end
end
