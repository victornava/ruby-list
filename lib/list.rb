class List
  class << self
    def [](*args)
      new(*args)
    end
  end

  # TODO get rid of this
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

  # TODO implement this
  def []=(index, value)
    @array[index] = value
  end

  # TODO implement this using enumerator
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
      result = List[]
      each do |e|
        # TODO try to do it without modifiying the list
        result << yield(e)
      end
      result
    else
      each
    end
  end

  def reduce(*args, &block)
    if args.size > 0
      memo = args.first
      rest = self
    else
      # TODO Use list rather than array
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

  def minmax(&block)
    List[min(&block), max(&block)]
  end

  def minmax_by(&block)
    if block_given?
      List[min_by(&block), max_by(&block)]
    else
      each
    end
  end

  # TODO This is extremelly slow :P use a faster algorithm
  def sort(&block)
    left = List[]
    right = self.dup

    while right.any?
      min = right.min(&block)
      right.select { |o| o == min }.each { |o| left << o }
      right = right.reject { |o| o == min }
    end

    left
  end

  def sort_by(&block)
    if block_given?
      sort { |l, r| yield(l) <=> yield(r) }
    else
      each
    end
  end

  def zip(*args, &block)
    # TODO use each_with_index
    result = (0..(size-1)).reduce(List[]) do |memo, i|
      temp = List[ self[i], *args.map { |arg| arg[i] } ]
      memo << ( block_given? ? yield(temp) : temp )
    end
    block_given? ? nil : result
  end

  def each_with_index(&block)
    each.with_index(&block)
    self
  end

  def each_with_object(obj, &block)
    each.with_object(obj, &block)
  end

  def flat_map(&block)
    return each unless block_given?

    reduce do |memo, elem|
      if elem.is_a?(List)
        List[*memo, *elem]
      else
        List[*memo, elem]
      end
    end
  end

  def to_a
    array = _array.dup
    array.taint if tainted?
    array.untrust if untrusted?
    array
  end

  def partition(&block)
    List[select(&block), reject(&block)]
  end

  # TODO This might just be the inverse of #all?
  def none?(&block)
    each do |elem|
      is_truthy = block_given? ? yield(elem) : elem
      return false if is_truthy
    end
    true
  end

  def take_while(&block)
    return each unless block_given?

    reduce(List[]) do |memo, elem|
      return memo unless (block_given? ? yield(elem) : elem)
      # TODO don't mutate. Could do memo + elem
      memo << elem
    end
  end

  private

  def count_where(&block)
    select(&block).reduce(0) { |memo| memo + 1 }
  end
end
