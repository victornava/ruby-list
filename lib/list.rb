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
    each do |elem|
      return true if yield_or(elem, &block)
    end
    false
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
      memo << yield_or(temp, &block)
    end
    block_given? ? nil : result
  end

  def each_with_index(&block)
    result = each.with_index(&block)
    block_given? ? self : result
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
      return false if yield_or(elem, &block)
    end
    true
  end

  def take_while(&block)
    return each unless block_given?

    reduce(List[]) do |memo, elem|
      return memo unless yield_or(elem, &block)
      # TODO don't mutate. Could do memo + elem
      memo << elem
    end
  end

  def drop_while(&block)
    return each unless block_given?

    reduce(self.dup) do |memo, elem|
      return memo unless yield_or(elem, &block)
      memo.drop(1)
    end
  end

  def find(ifnone = ->{}, &block)
    if block_given?
      found = select(&block)
      found.any? ? found.first : ifnone.call
    else
      each_with_object(ifnone.call)
    end
  end

  def include?(obj)
    any? {|elem| elem == obj }
  end

  def one?(&block)
    select { |elem| yield_or(elem, &block) }.size == 1
  end

  # TODO Do you smell something here?
  def find_index(arg=nil, &block)
    return each unless arg || block_given?

    each_with_index.map do |elem, index|
      if arg
        return index if arg == elem
      else
        return index if yield(elem)
      end
    end

    return nil
  end

  def grep(arg, &block)
    result = select { |elem| arg === elem }
    block_given? ? result.map(&block) : result
  end

  def reverse_each(&block)
    if block_given?
      reverse.each { |elem| yield(elem) }
      self
    else
      reverse.each
    end
  end

  def each_cons(arg, &block)
    cons = arg.to_int
    raise ArgumentError unless cons >= 1

    step_size = cons - 1
    indexes = List[*(0..(size - cons))]

    objects = indexes.map do |i|
      self[i..(i + step_size)]
    end

    if block_given?
      objects.each(&block)
      nil
    else
      objects.each
    end
  end

  def each_slice(arg, &block)
    n = arg.to_int
    raise ArgumentError unless n >= 1

    n = size if n > size
    slots = ((size / n) + (size % n))

    objects = slots.times.map do |step|
      from = step * n
      to = from + n - 1
      self[from..to]
    end

    if block_given?
      objects.each(&block)
      nil
    else
      objects.each
    end
  end

  # TODO I'm not happy with this code. It looks complicated.
  # Not sure if it's becauce the behariour of the method is complex or
  # I haven't understood it properly.
  def slice_before(arg=nil, &block)
    raise ArgumentError unless arg || block
    slice_here = ->(elem, arg, &block) do
      if block_given?
        arg ? yield(elem, arg.dup) : yield(elem)
      else
        arg === elem
      end
    end

    result = List[]
    section = List[]

    each do |elem|
      if slice_here.(elem, arg, &block) && section.any?
        result << section
        section = List[]
      end

      section << elem
    end

    result << section if section.any?
    result.each
  end

  def chunk(initial_state=nil, &block)
    raise ArgumentError unless block

    mapper = ->(e) { initial_state ? yield(e, initial_state.dup) : yield(e) }

    reducer = ->(memo, pair) do
      if memo.any? && memo[-1][0] == pair[0]
        memo[-1][1] << pair[1]
      else
        memo << List[pair[0], List[pair[1]]]
      end
      memo
    end

    rejector = ->(p) { p[0] == :_separator || p[0] == nil }

    map(&mapper).zip(self).reduce(List[], &reducer).reject(&rejector).each
  end

  def cycle(arg=nil, &block)
    return nil unless any?

    if arg.nil?
      while true do
        each(&block)
      end
    else
      raise TypeError unless arg.respond_to?(:to_int)
      n = arg.to_int
      raise TypeError unless n.is_a?(Integer)
      return nil unless n > 0
      n.times { each(&block) }
    end
  end

  private

  def reverse
    List[*(1..size)].map{ |i| self[-i] }
  end

  def count_where(&block)
    select(&block).reduce(0) { |memo| memo + 1 }
  end

  def yield_or(elem, &block)
    block_given? ? yield(elem) : elem
  end
end
