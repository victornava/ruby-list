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

  def <<(arg)
    @array << arg
    self
  end

  # Actual implementation

  def map(&block)
    if block_given?
      new_array = []
      each do |e|
        # TODO try to do it without modifiying the array
        new_array << yield(e)
      end
      List[*new_array]
    else
      each
    end
  end

  def reduce(*args, &block)
    if args.size > 0
      memo = args.first
      rest = self
    else
      memo, *rest = *@array
    end

    rest.each do |e|
      memo = yield(memo, e)
    end

    memo
  end

  def count(arg=nil, &block)
    case
    when arg
      count_where { |obj| obj == arg }
    when block_given?
      count_where &block
    else
      count_where { true }
    end
  end

  def select(&block)
    return each unless block_given?

    reduce(List[]) do |memo, obj|
      yield(obj) ? (memo << obj) : memo
    end
  end

  def reject(&block)
    return each unless block_given?

    reduce(List[]) do |memo, obj|
      yield(obj) ? memo : (memo << obj)
    end
  end

  def all?(&block)
    map(&block).reduce(true, &:&)
  end

  def any?(&block)
    map(&block).reduce(false, &:|)
  end

  def take(number)
    raise TypeError unless number.is_a?(Numeric)

    n = number.to_int

    case
    when n < 0
      raise ArgumentError
    when n == 0
      List[]
    when n > 0 && n <= size
      List[*n.times].map { |i| self[i] }
    else
      List[*self.each]
    end
  end

  def size
    count
  end

  def drop(n)
    raise TypeError unless n.is_a?(Numeric)

    case
    when n < 0
      raise ArgumentError
    when n == 0
      self
    when n > 0 && n <= size
      List[*(n..(size - 1))].map { |i| self[i] }
    else
      List[]
    end
  end

  # TODO Find a better way to test if an argument was given
  def first(n=:no_argument)
    n == :no_argument ? self[0] : take(n)
  end

  def min(&block)
    reduce do |memo, obj|
      memo_is_smaller = block_given? ? (0 <= yield(obj, memo)) : (memo < obj)
      memo_is_smaller ? memo : obj
    end
  end

  def min_by(&block)
    if block_given?
      reduce do |memo, obj|
        yield(memo) <= yield(obj) ? memo : obj
      end
    else
      each
    end
  end

  def max(&block)
    reduce do |memo, obj|
      memo_is_bigger = block_given? ? (0 <= yield(memo, obj)) : (memo > obj)
      memo_is_bigger ? memo : obj
    end
  end

  def max_by(&block)
    if block_given?
      reduce do |memo, obj|
        yield(memo) >= yield(obj) ? memo : obj
      end
    else
      each
    end
  end

  private

  def count_where(&block)
    select(&block).reduce(0) { |memo| memo + 1 }
  end
end