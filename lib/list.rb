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
    order_by ->(from) do
      from.find_index(from.min(&block))
    end
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

  # TODO fix this
  # def to_ary
  #   self
  # end

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

  def group_by(&block)
    reduce({}) do |memo, elem|
      key = yield(elem)
      if memo[key]
        memo[key] << elem
      else
        memo[key] = List[elem]
      end
      memo
    end
  end

  def lazy
    each.lazy
  end

  def reverse
    List[*(1..size)].map{ |i| self[-i] }
  end

  # TODO Find a better way to test if an argument was given
  def last(elem_count=:no_argument)
    if elem_count == :no_argument
      self[size - 1]
    else
      reverse.take(elem_count).reverse
    end
  end

  def empty?
    !any?
  end

  def uniq(&block)
    reduce(self.class[]) do |memo, elem|
      val = yield_or(elem, &block)
      memo << elem unless memo.any? { |x| x.eql?(val) }
      memo
    end
  end

  def compact
    select {|e| e }
  end

  def join(separator=$,)
    return '' if empty?
    flatten.map(&:to_s).reduce  { |memo, elem| memo << separator << elem }
  end

  # TODO use infinity as initial recusion level
  def flatten(recursion_level=5000)
    raise TypeError unless recursion_level.respond_to?(:to_int)
    recursion_level = recursion_level.to_int
    depth = recursion_level >= 0 ? recursion_level : 5000

    reduce(self.class[]) do |memo, elem|
      if elem.is_a?(List) && depth > 0
        self.class[*memo, *elem.flatten(depth-1)]
      else
        self.class[*memo, elem]
      end
    end
  end

  def shuffle(random: nil)
    order_by ->(from) do
      random && random.respond_to?(:rand) ? random.rand(from.size) : rand(from.size)
    end
  end

  def inspect
    convert = ->(elem) do
      if self == elem
        "[...]"
      elsif elem.is_a?(String)
        '"'+ elem + '"'
      else
        elem.inspect
      end
    end

    '[' + map(&convert).join(', ') + ']'
  end

  def eql?(other)
    return false unless other.is_a?(List)
    return false unless size == other.size
    zip(other).all? { |p| p.first == p.last && p.first.class == p.last.class }
  end

  def at(index)
    fetch(index, nil)
  end

  def fetch(index, default=:no_argument, &block)
    raise TypeError unless index.respond_to?(:to_int)
    i = index.to_int
    target_index = i >= 0 ? i : (size + i)

    each_with_index do |e, i|
      return e if target_index == i
    end

    if block_given?
      yield(index)
    elsif default == :no_argument
      raise(IndexError)
    else
      default
    end
  end

  def slice(*args)
    arg1, arg2 = args

    if arg1.is_a?(Range)
      range = arg1
      range_first = range.first.to_int rescue (raise TypeError)
      range_last = range.last.to_int rescue (raise TypeError)
      from = real_index(range_first)
      to = range.exclude_end? ? real_index(range_last) - 1 : real_index(range_last)
      x = to - from + 1
      n = x < 0 ? 0 : x
      sub_list(from, n)

    elsif arg1 && arg2
      from = real_index(arg1.to_int)
      n = arg2.to_int
      return nil if n < 0
      sub_list(from, n)

    else arg1
      at(arg1)
    end
  end

  def each_index(&block)
    (0...size).each(&block)
    self
  end

  # TODO Think about this again.
  def values_at(*args)
    args.reduce(List[]) do |memo, arg|
      if arg.is_a?(Range)
        from = real_index(arg.first.to_int)
        to = real_index(arg.exclude_end? ? arg.last.to_int - 1 : arg.last.to_int)

        memo << case
        when from < to
          List[*(from..to)].map { |i| at(i) }
        when from > to
          List[]
        else
          at(arg)
        end
      else
        memo << self[arg]
      end
      memo
    end.flatten
  end

  def sample(random: nil)
    at(random ? random.rand(size) : rand(size))
  end

  def rotate(places=1)
    return self.dup if (size == 0 || size == 1)

    n = places.to_int rescue (raise TypeError)
    mod = n.abs % size

    if n > 0
      List[drop(mod), take(mod)].flatten
    else
      List[reverse.take(mod).reverse, reverse.drop(mod).reverse].flatten
    end
  end

  # Transfer an object from a list to another list by the given index
  # List.transfer(1, List[1, 2, 3], List[4]) -> [[1, 3],[4, 2]]
  def self.transfer(index, from, to)
    List[
      List[*from.each_with_index].reject { |elem, i|  index == i }.map(&:first),
      List[*to, from[index]]
    ]
  end

  private

  def real_index(relative_index)
    relative_index >= 0 ? relative_index : size - relative_index.abs
  end

  def sub_list(from, n)
    return nil if from > size || from < 0
    self.class[*drop(from).take(n)]
  end

  def order_by(index_finder)
    reduce(List[self.dup, List[]]) do |memo, _|
      from, to = *memo
      List.transfer(index_finder.call(from), from, to)
    end.last
  end

  def count_where(&block)
    select(&block).reduce(0) { |memo| memo + 1 }
  end

  def yield_or(elem, &block)
    block_given? ? yield(elem) : elem
  end

  alias_method :[], :slice
end
