class List
  class << self
    def [](*args)
      new(*args)
    end
  end

  def _array
    @array
  end

  # Delegate to Array

  def initialize(*args)
    @array = Array[*args]
  end

  def [](*args)
    @array[*args]
  end

  def each(*args, &block)
    @array.each(*args, &block)
  end

  def ==(other)
    return false unless self.class == other.class
    @array == other._array
  end

  # Actual implementation
  def map(&block)
    new_array = []
    @array.each do |e|
      # TODO try to do it without modifiying the array
      new_array << (yield e)
    end
    List[*new_array]
  end
end