require 'spec_helper'

describe "::[]" do
  it "returns a new list populated with the given elements" do
    obj = Object.new
    List[5, true, nil, 'a', "Ruby", obj]._array.should == [5, true, nil, "a", "Ruby", obj]
  end
end

describe "#[]" do
  it "delegates to List" do
    List[0,1,2][1].should == 1
  end
end

describe "#each" do
  it "delegates to List" do
    List[1,2].each.inspect.should  == [1,2].each.inspect
  end
end

describe "#==" do
  it "delegates to List" do
    List[1,2].should == List[1,2]
  end
end

describe "#map" do
  it "returns a copy of list with each element replaced by the value returned by block" do
    a = List['a', 'b', 'c', 'd']
    b = a.map { |i| i + '!' }
    b.should == List["a!", "b!", "c!", "d!"]
    b.object_id.should_not == a.object_id
  end

  it "does not return subclass instance" do
    List[1, 2, 3].map { |x| x + 1 }.should be_an_instance_of(List)
  end

  it "does not change self" do
    a = List['a', 'b', 'c', 'd']
    b = a.map { |i| i + '!' }
    a.should == List['a', 'b', 'c', 'd']
  end

  it "returns the evaluated value of block if it broke in the block" do
    a = List['a', 'b', 'c', 'd']
    b = a.map {|i|
      if i == 'c'
        break 0
      else
        i + '!'
      end
    }
    b.should == 0
  end

  it "returns an Enumerator when no block given" do
    l = List[1, 2, 3]
    l.map.should be_an_instance_of(Enumerator)
  end

  it "does not copy tainted status" do
    a = List[1, 2, 3]
    a.taint
    a.map {|x| x}.tainted?.should be_false
  end

  it "does not copy untrusted status" do
    a = List[1, 2, 3]
    a.untrust
    a.map {|x| x}.untrusted?.should be_false
  end
end

describe "#reduce" do

  before do
    @list = List[2, 5, 3, 6, 1, 4]
  end

  it "with argument takes a block with an accumulator (with argument as initial value) and the current element. Value of block becomes new accumulator" do
    a = []
    @list.reduce(0) { |memo, i| a << [memo, i]; i }
    a.should == [[0, 2], [2, 5], [5, 3], [3, 6], [6, 1], [1, 4]]
    List[true, true, true].reduce(nil) {|result, i| i && result}.should == nil
  end

  it "produces an list of the accumulator and the argument when given a block with a *arg" do
    a = []
    List[1,2].reduce(0) {|*args| a << args; args[0] + args[1]}
    a.should == [[0, 1], [1, 2]]
  end

  it "without argument takes a block with an accumulator (with first element as initial value) and the current element. Value of block becomes new accumulator" do
    a = []
    @list.reduce { |memo, i| a << [memo, i]; i }
    a.should == [[2, 5], [5, 3], [3, 6], [6, 1], [1, 4]]
  end

  it "gathers whole lists as elements when each yields multiple" do
    List[List[1,2], List[3,4,5]].reduce(List[]) {|acc, e| acc << e }.should == List[List[1,2], List[3,4,5]]
  end

  it "with inject arguments" do
    List[].reduce(1) {|acc,x| 999 }.should == 1
    List[2].reduce(1) {|acc,x| 999 }.should ==  999
    List[2].reduce(1) {|acc,x| acc }.should == 1
    List[2].reduce(1) {|acc,x| x }.should == 2
    List[1,2,3,4].reduce(100) {|acc,x| acc + x }.should == 110
    List[1,2,3,4].reduce(100) {|acc,x| acc * x }.should == 2400
    List['a','b','c'].reduce("z") {|result, i| i+result}.should == "cbaz"
  end

  it "without inject arguments" do
    List[2].reduce {|acc,x| 999 } .should == 2
    List[2].reduce {|acc,x| acc }.should == 2
    List[2].reduce {|acc,x| x }.should == 2
    List[1,2,3,4].reduce {|acc,x| acc + x }.should == 10
    List[1,2,3,4].reduce {|acc,x| acc * x }.should == 24
    List['a', 'b', 'c'].reduce {|result, i| i+result}.should == "cba"
    List[3,4,5].reduce {|result, i| result*i}.should == 60
    List[List[1], 2, 'a','b'].reduce {|r,i| r<<i}.should == List[1, 2, 'a', 'b']
  end

  it "returns nil when fails" do
    List[].reduce {|acc,x| 999 }.should == nil
  end
end

describe "#count" do
  it "returns the number of elements" do
    List[:a, :b, :c].count.should == 3
  end

  it "returns the number of elements that equal the argument" do
    List[:a, :b, :b, :c].count(:b).should == 2
  end

  it "returns the number of element for which the block evaluates to true" do
    List[:a, :b, :c].count { |s| s != :b }.should == 2
  end
end

describe "#select" do
  it "returns an Enumerator if no block given" do
    [1,2].select.should be_an_instance_of(Enumerator)
  end

  it "returns a new List of elements for which block is true" do
    List[1, 3, 4, 5, 6, 9].select { |i| i % 2 == 0}.should == List[4, 6]
  end

  it "does not return subclass instance on List subclasses" do
    ListSubclass[1, 2, 3].select { true }.should be_an_instance_of(List)
  end

  it "properly handles recursive lists" do
    empty = ListSpecs.empty_recursive_list
    empty.select { true }.should == empty
    empty.select { false }.should == List[]

    list = ListSpecs.recursive_list
    list.select { true }.should == list
    list.select { false }.should == List[]
  end
end

describe "#reject" do
  it "returns a new list without elements for which block is true" do
    list = List[1, 2, 3, 4, 5]
    list.reject { true }.should == List[]
    list.reject { false }.should == list
    list.reject { false }.object_id.should_not == list.object_id
    list.reject { nil }.should == list
    list.reject { nil }.object_id.should_not == list.object_id
    list.reject { 5 }.should == List[]
    list.reject { |i| i < 3 }.should == List[3, 4, 5]
    list.reject { |i| i % 2 == 0 }.should == List[1, 3, 5]
  end

  it "properly handles recursive lists" do
    empty = ListSpecs.empty_recursive_list
    empty.reject { false }.should == List[empty]
    empty.reject { true }.should == List[]

    list = ListSpecs.recursive_list
    list.reject { false }.should == list
    list.reject { true }.should == List[]
  end

  it "does not return subclass instance on List subclasses" do
    ListSubclass[1, 2, 3].reject { |x| x % 2 == 0 }.should be_an_instance_of(List)
  end

  it "does not retain instance variables" do
    list = List[]
    list.instance_variable_set("@variable", "value")
    list.reject { false }.instance_variable_get("@variable").should == nil
  end

  it "returns an Enumerator if no block given" do
    [1,2].reject.should be_an_instance_of(Enumerator)
  end
end

describe "#all?" do
  before :each do
    @empty = List[]
    @list1 = List[0, 1, 2, -1]
    @list2 = List[nil, false, true]
  end

  it "always returns true on empty enumeration" do
    @empty.all?.should == true
    @empty.all? { nil }.should == true
  end

  it "does not hide exceptions out of #each" do
    lambda {
      ListThrowingErrorOnEach.new.all?
    }.should raise_error(RuntimeError)

    lambda {
      ListThrowingErrorOnEach.new.all? { false }
    }.should raise_error(RuntimeError)
  end

  describe "with no block" do
    it "returns true if no elements are false or nil" do
      @list1.all?.should == true
      @list2.all?.should == false
      List['a','b','c'].all?.should == true
      List[0, "x", true].all?.should == true
    end

    it "returns false if there are false or nil elements" do
      List[false].all?.should == false
      List[false, false].all?.should == false

      List[nil].all?.should == false
      List[nil, nil].all?.should == false

      List[1, nil, 2].all?.should == false
      List[0, "x", false, true].all?.should == false
    end
  end

  describe "with block" do
    it "returns true if the block never returns false or nil" do
      @list1.all? { true }.should == true
      @list1.all?{ |o| o < 5 }.should == true
      @list1.all?{ |o| 5 }.should == true
    end

    it "returns false if the block ever returns false or nil" do
      @list1.all? { false }.should == false
      @list1.all? { nil }.should == false
      @list1.all?{ |o| o > 2 }.should == false

      ListSpecs.numerous.all? { |i| i > 5 }.should == false
      ListSpecs.numerous.all? { |i| i == 3 ? nil : true }.should == false
    end

    it "does not hide exceptions out of the block" do
      lambda {
        @list1.all? { raise "from block" }
      }.should raise_error(RuntimeError)
    end
  end
end

describe "#any?" do
  before :each do
    @list  = ListSpecs.numerous
    @empty = List[]
    @list1 = [0, 1, 2, -1]
    @list2 = [nil, false, true]
  end

  it "always returns false on empty enumeration" do
    @empty.any?.should == false
    @empty.any? { nil }.should == false
  end

  it "raises an ArgumentError when any arguments provided" do
    lambda { @list.any?(Proc.new {}) }.should raise_error(ArgumentError)
    lambda { @list.any?(nil) }.should raise_error(ArgumentError)
    lambda { @empty.any?(1) }.should raise_error(ArgumentError)
    lambda { @list1.any?(1) {} }.should raise_error(ArgumentError)
    lambda { @list2.any?(1, 2, 3) {} }.should raise_error(ArgumentError)
  end

  it "does not hide exceptions out of #each" do
    lambda {
      ListThrowingErrorOnEach.new.any?
    }.should raise_error(RuntimeError)

    lambda {
      ListThrowingErrorOnEach.new.any? { false }
    }.should raise_error(RuntimeError)
  end

  describe "with no block" do
    it "returns true if any element is not false or nil" do
      @list.any?.should == true
      @list1.any?.should == true
      @list2.any?.should == true
      List[true].any?.should == true
      List['a','b','c'].any?.should == true
      List['a','b','c', nil].any?.should == true
      List[1, nil, 2].any?.should == true
      List[1, false].any?.should == true
      List[false, nil, 1, false].any?.should == true
      List[false, 0, nil].any?.should == true
    end

    it "returns false if all elements are false or nil" do
      List[false].any?.should == false
      List[false, false].any?.should == false
      List[nil].any?.should == false
      List[nil, nil].any?.should == false
      List[nil, false, nil].any?.should == false
    end
  end

  describe "with block" do
    it "returns true if the block ever returns other than false or nil" do
      @list.any? { true } == true
      @list.any? { 0 } == true
      @list.any? { 1 } == true

      @list1.any? { Object.new } == true
      @list1.any?{ |o| o < 1 }.should == true
      @list1.any?{ |o| 5 }.should == true

      @list2.any? { |i| i == nil }.should == true
    end

    it "any? should return false if the block never returns other than false or nil" do
      @list.any? { false }.should == false
      @list.any? { nil }.should == false

      @list1.any?{ |o| o < -10 }.should == false
      @list1.any?{ |o| nil }.should == false

      @list2.any? { |i| i == :stuff }.should == false
    end

    it "stops iterating once the return value is determined" do
      yielded = []
      List[:one, :two, :three].any? do |e|
        yielded << e
        false
      end.should == false
      yielded.should == [:one, :two, :three]

      yielded = []
      List[true, true, false, true].any? do |e|
        yielded << e
        e
      end.should == true
      yielded.should == [true]

      yielded = []
      List[false, nil, false, true, false].any? do |e|
        yielded << e
        e
      end.should == true
      yielded.should == [false, nil, false, true]

      yielded = []
      List[1, 2, 3, 4, 5].any? do |e|
        yielded << e
        e
      end.should == true
      yielded.should == [1]
    end


    it "does not hide exceptions out of the block" do
      lambda {
        @list.any? { raise "from block" }
      }.should raise_error(RuntimeError)
    end
  end
end

describe "#take" do
  before :each do
    @list = List[4,3,2,1,0,-1]
  end

  it "returns the first count elements if given a count" do
    @list.take(2).should == List[4, 3]
    @list.take(4).should == List[4, 3, 2, 1]
  end

  it "returns an empty List when passed count on an empty List" do
    empty = List[]
    empty.take(0).should == empty
    empty.take(1).should == empty
    empty.take(2).should == empty
  end

  it "returns an empty List when passed count == 0" do
    @list.take(0).should == List[]
  end

  it "returns an List containing the first element when passed count == 1" do
    @list.take(1).should.should == List[4]
  end

  it "raises an ArgumentError when count is negative" do
    lambda { @list.take(-1) }.should raise_error(ArgumentError)
  end

  it "returns the entire List when count > length" do
    @list.take(100).should == @list
    @list.take(8).should == @list
  end

  it "raises a TypeError if the passed argument is not numeric" do
    lambda { @list.take(nil) }.should raise_error(TypeError)
    lambda { @list.take("a") }.should raise_error(TypeError)

    obj = double("nonnumeric")
    lambda { @list.send(@method, obj) }.should raise_error(TypeError)
  end
end

describe "#size" do
  it "returns the number of elements" do
    List[].size.should == 0
    List[1, 2, 3].size.should == 3
  end

  it "properly handles recursive Lists" do
    ListSpecs.empty_recursive_list.size.should == 1
    ListSpecs.recursive_list.size.should == 8
  end
end

describe "#drop" do
  it "removes the specified number of elements from the start of the List" do
    List[1, 2, 3, 4, 5].drop(2).should == List[3, 4, 5]
  end

  it "raises an ArgumentError if the number of elements specified is negative" do
    lambda { List[1, 2].drop(-3) }.should raise_error(ArgumentError)
  end

  it "returns an empty List if all elements are dropped" do
    List[1, 2].drop(2).should == List[]
  end

  it "returns an empty List when called on an empty List" do
    List[].drop(0).should == List[]
  end

  it "does not remove any elements when passed zero" do
    List[1, 2].drop(0).should == List[1, 2]
  end

  it "returns an empty List if more elements than exist are dropped" do
    List[1, 2].drop(3).should == List[]
  end
end

describe "#first" do
  it "returns the first element" do
    List['a', 'b', 'c'].first.should == 'a'
    List[nil].first.should == nil
  end

  it "returns nil if self is empty" do
    List[].first.should == nil
  end

  it "returns the first count elements if given a count" do
    List[true, false, true, nil, false].first(2).should == List[true, false]
  end

  it "returns an empty list when passed count on an empty list" do
    List[].first(0).should == List[]
    List[].first(1).should == List[]
    List[].first(2).should == List[]
  end

  it "returns an empty List when passed count == 0" do
    List[1, 2, 3, 4, 5].first(0).should == List[]
  end

  it "returns an List containing the first element when passed count == 1" do
    List[1, 2, 3, 4, 5].first(1).should == List[1]
  end

  it "raises an ArgumentError when count is negative" do
    lambda { List[1, 2].first(-1) }.should raise_error(ArgumentError)
  end

  it "returns the entire List when count > length" do
    List[1, 2, 3, 4, 5, 9].first(10).should == List[1, 2, 3, 4, 5, 9]
  end

  it "properly handles recursive Lists" do
    empty = ListSpecs.empty_recursive_list
    empty.first.should equal(empty)

    list = ListSpecs.head_recursive_list
    list.first.should equal(list)
  end

  it "it works when given a float" do
    List[1, 2, 3, 4, 5].first(2.5).should == List[1, 2]
  end

  it "raises a TypeError if the passed argument is not numeric" do
    lambda { List[1,2].first(nil) }.should raise_error(TypeError)
    lambda { List[1,2].first("a") }.should raise_error(TypeError)

    obj = double("nonnumeric")
    lambda { List[1,2].first(obj) }.should raise_error(TypeError)
  end

  it "does not return subclass instance when passed count on List subclasses" do
    ListSubclass[].first(0).should be_an_instance_of(List)
    ListSubclass[].first(2).should be_an_instance_of(List)
    ListSubclass[1, 2, 3].first(0).should be_an_instance_of(List)
    ListSubclass[1, 2, 3].first(1).should be_an_instance_of(List)
    ListSubclass[1, 2, 3].first(2).should be_an_instance_of(List)
  end

  it "is not destructive" do
    a = List[1, 2, 3]
    a.first
    a.should == List[1, 2, 3]
    a.first(2)
    a.should == List[1, 2, 3]
    a.first(3)
    a.should == List[1, 2, 3]
  end
end

describe "#min" do
  before :each do
    @l = List[2, 4, 6, 8, 10]
    @l_strs = List["333", "22", "666666", "1", "55555", "1010101010"]
    @l_ints = List[ 333,   22,   666666,   55555, 1010101010]
  end

  it "min should return the minimum element" do
    ListSpecs.numerous.min.should == 1
  end

  it "returns the minimum (basic cases)" do
    List[55].min.should == 55

    List[11,99].min.should ==  11
    List[99,11].min.should == 11
    List[2, 33, 4, 11].min.should == 2

    List[1,2,3,4,5].min.should == 1
    List[5,4,3,2,1].min.should == 1
    List[4,1,3,5,2].min.should == 1
    List[5,5,5,5,5].min.should == 5

    List["aa","tt"].min.should == "aa"
    List["tt","aa"].min.should == "aa"
    List["2","33","4","11"].min.should == "11"

    @l_strs.min.should == "1"
    @l_ints.min.should == 22
  end

  it "returns nil for an empty list" do
    List[].min.should be_nil
  end

  it "raises a NoMethodError for elements without #<=>" do
    lambda do
      List[Object.new, Object.new].max
    end.should raise_error(NoMethodError)
  end

  it "raises an ArgumentError for incomparable elements" do
    lambda do
      List[11,"22"].min
    end.should raise_error(ArgumentError)

    lambda do
      List[11,12,22,33].min{|a, b| nil}
    end.should raise_error(ArgumentError)
  end

  it "returns the minimum when using a block rule" do
    List["2","33","4","11"].min {|a,b| a <=> b }.should == "11"
    List[ 2 , 33 , 4 , 11 ].min {|a,b| a <=> b }.should == 2
    List["2","33","4","11"].min {|a,b| b <=> a }.should == "4"
    List[2 , 33 , 4 , 11 ].min {|a,b| b <=> a }.should == 33
    List[1, 2, 3, 4].min {|a,b| 15 }.should == 1
    List[11,12,22,33].min{|a, b| 2 }.should == 11

    @i = -2
    List[11,12,22,33].min{|a, b| @i += 1 }.should == 12

    @l_strs.min {|a,b| a.length <=> b.length }.should == "1"
    @l_strs.min {|a,b| a <=> b }.should == "1"
    @l_strs.min {|a,b| a.to_i <=> b.to_i }.should == "1"
    @l_ints.min {|a,b| a <=> b }.should == 22
    @l_ints.min {|a,b| a.to_s <=> b.to_s }.should == 1010101010
  end

  it "returns the minimum for lists that contain nils" do
    list = List[nil, nil, true]
    list.min { |a, b|
      x = a.nil? ? -1 : a ? 0 : 1
      y = b.nil? ? -1 : b ? 0 : 1
      x <=> y
    }.should == nil
  end
end

describe "#min_by" do
  it "returns an enumerator if no block" do
    List[42].min_by.should be_an_instance_of(Enumerator)
  end

  it "returns nil if #each yields no objects" do
    List[].min_by {|o| o.nonesuch }.should == nil
  end

  it "returns the object for whom the value returned by block is the largest" do
    List['3', '2', '1'].min_by {|obj| obj.to_i }.should == '1'
    List['five', 'three'].min_by {|obj| obj.length }.should == 'five'
  end

  it "returns the object that appears first in #each in case of a tie" do
    a, b, c = '2', '1', '1'
    List[a, b, c].min_by {|obj| obj.to_i }.should equal(b)
  end

  it "uses min.<=>(current) to determine order" do
    a, b, c = (1..3).map{|n| ReverseComparable.new(n)}

    # Just using self here to avoid additional complexity
    List[a, b, c].min_by {|obj| obj }.should == c
  end

  it "is able to return the maximum for enums that contain nils" do
    list = List[nil, nil, true]
    list.min_by {|o| o.nil? ? 0 : 1 }.should == nil
    list.min_by {|o| o.nil? ? 1 : 0 }.should == true
  end
end

describe "#max" do
  before :each do
    @l = List[2, 4, 6, 8, 10]
    @l_strs = List["333", "22", "666666", "1", "55555", "1010101010"]
    @l_ints = List[ 333,   22,   666666,   55555, 1010101010]
  end

  it "max should return the maximum element" do
    ListSpecs.numerous.max.should == 6
  end

  it "returns the maximum element (basics cases)" do
    List[55].max.should == 55

    List[11,99].max.should == 99
    List[99,11].max.should == 99
    List[2, 33, 4, 11].max.should == 33

    List[1,2,3,4,5].max.should == 5
    List[5,4,3,2,1].max.should == 5
    List[1,4,3,5,2].max.should == 5
    List[5,5,5,5,5].max.should == 5

    List["aa","tt"].max.should == "tt"
    List["tt","aa"].max.should == "tt"
    List["2","33","4","11"].max.should == "4"

    @l_strs.max.should == "666666"
    @l_ints.max.should == 1010101010
  end

  it "returns nil for an empty Enumerable" do
    List[].max.should == nil
  end

  it "raises a NoMethodError for elements without #<=>" do
    lambda do
      List[Object.new, Object.new].max
    end.should raise_error(NoMethodError)
  end

  it "raises an ArgumentError for incomparable elements" do
    lambda do
      List[11,"22"].max
    end.should raise_error(ArgumentError)
    lambda do
      List[11,12,22,33].max{|a, b| nil}
    end.should raise_error(ArgumentError)
  end

  it "returns the maximum element (with block)" do
    List["2","33","4","11"].max {|a,b| a <=> b }.should == "4"
    List[ 2 , 33 , 4 , 11 ].max {|a,b| a <=> b }.should == 33

    List["2","33","4","11"].max {|a,b| b <=> a }.should == "11"
    List[ 2 , 33 , 4 , 11 ].max {|a,b| b <=> a }.should == 2

    @l_strs.max {|a,b| a.length <=> b.length }.should == "1010101010"

    @l_strs.max {|a,b| a <=> b }.should == "666666"
    @l_strs.max {|a,b| a.to_i <=> b.to_i }.should == "1010101010"

    @l_ints.max {|a,b| a <=> b }.should == 1010101010
    @l_ints.max {|a,b| a.to_s <=> b.to_s }.should == 666666
  end

  it "returns the minimum for enumerables that contain nils" do
    list = List[nil, nil, true]
    list.max { |a, b|
      x = a.nil? ? 1 : a ? 0 : -1
      y = b.nil? ? 1 : b ? 0 : -1
      x <=> y
    }.should == nil
  end
end

describe "#max_by" do
  it "returns an enumerator if no block" do
    List[42].max_by.should be_an_instance_of(Enumerator)
  end

  it "returns nil if #each yields no objects" do
    List[].max_by {|o| o.nonesuch }.should == nil
  end

  it "returns the object for whom the value returned by block is the largest" do
    List['1', '2', '3'].max_by {|obj| obj.to_i }.should == '3'
    List['three', 'five'].max_by {|obj| obj.length }.should == 'three'
  end

  it "returns the object that appears first in #each in case of a tie" do
    a, b, c = '1', '2', '2'
    List[a, b, c].max_by {|obj| obj.to_i }.should equal(b)
  end

  it "uses max.<=>(current) to determine order" do
    a, b, c = (1..3).map{|n| ReverseComparable.new(n)}

    # Just using self here to avoid additional complexity
    List[a, b, c].max_by {|obj| obj }.should == a
  end

  it "is able to return the maximum for enums that contain nils" do
    list = List[nil, nil, true]
    list.max_by {|o| o.nil? ? 0 : 1 }.should == true
    list.max_by {|o| o.nil? ? 1 : 0 }.should == nil
  end
end

describe "#minmax" do
  before :each do
    @list = List[6, 4, 5, 10, 8]
    @strs = List["333", "2", "60", "55555", "1010", "111"]
  end

  it "min should return the minimum element" do
    @list.minmax.should == List[4, 10]
    @strs.minmax.should == List["1010", "60"]
  end

  it "returns [nil, nil] for an empty List" do
    List[].minmax.should == List[nil, nil]
  end

  it "raises an ArgumentError when elements are incomparable" do
    lambda do
      List[11,"22"].minmax
    end.should raise_error(ArgumentError)

    lambda do
      List[11,12,22,33].minmax{|a, b| nil}
    end.should raise_error(ArgumentError)
  end

  it "raises a NoMethodError for elements without #<=>" do
    lambda do
      List[Object.new, Object.new].minmax
    end.should raise_error(NoMethodError)
  end

  it "returns the minimum when using a block rule" do
    @list.minmax {|a,b| b <=> a }.should == List[10, 4]
    @strs.minmax {|a,b| a.length <=> b.length }.should == List["2", "55555"]
  end
end

describe "#minmax_by" do
  it "returns an enumerator if no block" do
    List[42].minmax_by.should be_an_instance_of(Enumerator)
  end

  it "returns nil if #each yields no objects" do
    List[].minmax_by {|o| o.nonesuch }.should == List[nil, nil]
  end

  it "returns the object for whom the value returned by block is the largest" do
    List['1', '2', '3'].minmax_by {|obj| obj.to_i }.should == List['1', '3']
    List['three', 'five'].minmax_by {|obj| obj.length }.should == List['five', 'three']
  end

  it "returns the object that appears first in #each in case of a tie" do
    a, b, c, d = '1', '1', '2', '2'
    mm = List[a, b, c, d].minmax_by {|obj| obj.to_i }
    mm[0].should equal(a)
    mm[1].should equal(c)
  end

  it "uses min/max.<=>(current) to determine order" do
    a, b, c = (1..3).map{|n| ReverseComparable.new(n)}

    # Just using self here to avoid additional complexity
    List[a, b, c].minmax_by {|obj| obj }.should == List[c, a]
  end

  it "is able to return the maximum for enums that contain nils" do
    list = List[nil, nil, true]
    list.minmax_by {|o| o.nil? ? 0 : 1 }.should == List[nil, true]
  end
end

describe "#sort" do
  it "returns a new list sorted based on comparing elements with <=>" do
    l = List[1, -2, 3, 9, 1, 5, -5, 1000, -5, 2, -10, 14, 6, 23, 0]
    l.sort.should == List[-10, -5, -5, -2, 0, 1, 1, 2, 3, 5, 6, 9, 14, 23, 1000]
  end

  it "does not affect the original List" do
    a = List[0, 15, 2, 3, 4, 6, 14, 5, 7, 12, 8, 9, 1, 10, 11, 13]
    b = a.sort
    a.should == List[0, 15, 2, 3, 4, 6, 14, 5, 7, 12, 8, 9, 1, 10, 11, 13]
    b.should == List[*(0..15)]
  end

  it "sorts already-sorted Lists" do
    List[*(0..15)].sort.should == List[*(0..15)]
  end

  it "sorts reverse-sorted Lists" do
    List[*(0..15).to_a.reverse].sort.should == List[*(0..15)]
  end

  it "sorts Lists that consist entirely of equal elements" do
    class SortSame
      def <=>(other); 0; end
      def ==(other); true; end
    end

    l = List[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
    l.sort.should == l
    b = List.new(15).map { SortSame.new }
    b.sort.should == b
  end

  it "sorts Lists that consist mostly of equal elements" do
    l = List[1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1]
    l.sort.should == List[0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
  end

  it "does not return self even if the List would be already sorted" do
    l = List[1, 2, 3]
    sorted = l.sort
    sorted.should == l
    sorted.should_not equal(l)
  end

  it "properly handles recursive Lists" do
    empty = ListSpecs.empty_recursive_list
    empty.sort.should == empty

    # TODO No idea why this fails. Maybe there is something wrong with #==
    # list = List[List[]]; list << list
    # list.sort.should == List[List[], list]
  end

  it "does not deal with exceptions raised by unimplemented or incorrect #<=>" do
    o = Object.new

    lambda { List[o, 1].sort }.should raise_error
  end

  it "may take a block which is used to determine the order of objects a and b described as -1, 0 or +1" do
    l = [5, 1, 4, 3, 2]
    l.sort.should == [1, 2, 3, 4, 5]
    l.sort {|x, y| y <=> x}.should == [5, 4, 3, 2, 1]
  end

  it "raises an error when a given block returns nil" do
    lambda { List[1, 2].sort {} }.should raise_error(ArgumentError)
  end

  it "does not call #<=> on contained objects when invoked with a block" do
    l = List[*(0..25)]
    (0..25).each {|i| l[i] = UFOSceptic.new }

    l.sort { -1 }.should be_an_instance_of(List)
  end

  it "completes when supplied a block that always returns the same result" do
    l = List[2, 3, 5, 1, 4]
    l.sort {  1 }.should be_an_instance_of(List)
    l.sort {  0 }.should be_an_instance_of(List)
    l.sort { -1 }.should be_an_instance_of(List)
  end

  it "does not freezes self while being sorted" do
    l = List[1, 2, 3]
    l.sort { |x,y| l.frozen?.should == false; x <=> y }
  end

  it "returns the specified value when it would break in the given block" do
    List[1, 2, 3].sort{ break :a }.should == :a
  end

  it "uses the sign of Bignum block results as the sort result" do
    l = List[1, 2, 5, 10, 7, -4, 12]
    begin
      class Bignum;
        alias old_spaceship <=>
        def <=>(other)
          raise
        end
      end
      l.sort {|n, m| (n - m) * (2 ** 200)}.should == List[-4, 1, 2, 5, 7, 10, 12]
    ensure
      class Bignum
        alias <=> old_spaceship
      end
    end
  end

  it "compares values returned by block with 0" do
    l = List[1, 2, 5, 10, 7, -4, 12]
    target = List[-4, 1, 2, 5, 7, 10, 12]
    l.sort { |n, m| n - m }.should == target
    lambda {
      l.sort { |n, m| (n - m).to_s }
    }.should raise_error(ArgumentError)
  end


  it "raises an error if objects can't be compared" do
    lambda { List[1, 'a'].sort }.should raise_error(ArgumentError)
  end

  it "does not return subclass instance on List subclasses" do
    subclass = ListSubclass[1, 2, 3]
    subclass.sort.should be_an_instance_of(List)
  end
end

describe "#sort_by" do
  it "returns an array of elements ordered by the result of block" do
    l = List["once", "upon", "a", "time"]
    l.sort_by { |i| i[0] }.should == List["a", "once", "time", "upon"]
  end

  it "sorts the object by the given attribute" do
    class Dummy
      def initialize(s) ; @s = s ; end
      def s ; @s ; end
    end

    a = Dummy.new("fooo")
    b = Dummy.new("bar")

    ar = List[a, b].sort_by { |d| d.s }
    ar.should ==List[b, a]
  end

  it "returns an Enumerator when a block is not supplied" do
    l = List["a","b"]
    l.sort_by.should be_an_instance_of(Enumerator)
  end
end

describe "#zip" do
  it "combines each element of the receiver with the element of the same index in lists given as arguments" do
    List[1,2,3].zip(List[4,5,6], List[7,8,9]).should == List[List[1,4,7], List[2,5,8], List[3,6,9]]
    List[1,2,3].zip.should == List[List[1], List[2], List[3]]
  end

  it "passes each element of the result list to a block and return nil if a block is given" do
    expected = List[List[1,4,7], List[2,5,8], List[3,6,9]]
    List[1,2,3].zip(List[4,5,6], List[7,8,9]) do |result_component|
      result_component.should == expected.first
      expected = expected.drop(1)
    end.should == nil
    expected.size.should == 0
  end

  it "fills resulting list with nils if an argument array is too short" do
    List[1,2,3].zip(List[4,5,6], List[7,8]).should == List[List[1,4,7], List[2,5,8], List[3,6,nil]]
  end

  it "returns an list of lists containing corresponding elements of each list" do
    List[1, 2, 3, 4].zip(List["a", "b", "c", "d", "e"]).should ==
    List[List[1, "a"], List[2, "b"], List[3, "c"], List[4, "d"]]
  end

  it "fills in missing values with nil" do
    List[1, 2, 3, 4, 5].zip(List["a", "b", "c", "d"]).should ==
    List[List[1, "a"], List[2, "b"], List[3, "c"], List[4, "d"], List[5, nil]]
  end

  it "properly handles recursive arrays" do
    a = List[List[]]
    b = List[1, List[1]]

    a.zip(a).should == List[ List[a[0], a[0]] ]
    a.zip(b).should == List[ List[a[0], b[0]] ]
    b.zip(a).should == List[ List[b[0], a[0]], List[b[1], a[1]] ]
    b.zip(b).should == List[ List[b[0], b[0]], List[b[1], b[1]] ]
  end

  # TODO Not sure if I care about this
  # it "calls #to_ary to convert the argument to an Array" do
  #   obj = mock('List[3,4]')
  #   obj.should_receive(:to_ary).and_return([3, 4])
  #   List[1, 2].zip(obj).should == List[List[1, 3], List[2, 4]]
  # end
  #
  # it "uses #each to extract arguments' elements when #to_ary fails" do
  #   obj = Class.new do
  #     def each(&b)
  #       [3,4].each(&b)
  #     end
  #   end.new
  #   List[1, 2].zip(obj).should == List[List[1, 3], List[2, 4]]
  # end

  it "calls block if supplied" do
    values = List[]
    List[1, 2, 3, 4].zip(["a", "b", "c", "d", "e"]) { |value|
      values << value
    }.should == nil

    values.should == List[List[1, "a"], List[2, "b"], List[3, "c"], List[4, "d"]]
  end

  it "does not return subclass instance on Array subclasses" do
    ListSubclass[1, 2, 3].zip(List["a", "b"]).should be_an_instance_of(List)
  end
end

describe "#each_with_index" do

  before :each do
    @b = List[2, 5, 3, 6]
    @c = List[List[2, 0], List[5, 1], List[3, 2], List[6, 3]]
  end

  it "passes each element and its index to block" do
    @a = List[]
    @b.each_with_index { |o, i| @a << List[o, i] }
    @a.should == @c
  end

  it "provides each element to the block" do
    acc = List[]
    obj = List[]
    res = obj.each_with_index { |a,i| acc << List[a,i] }
    acc.should == List[]
    obj.should == res
  end

  it "provides each element to the block and its index" do
    acc = List[]
    res = @b.each_with_index {|a,i| acc << List[a,i]}
    @c.should == acc
    res.should eql(@b)
  end

  it "binds splat arguments properly" do
    acc = List[]
    res = @b.each_with_index { |*b| c,d = b; acc << c; acc << d }
    List[2, 0, 5, 1, 3, 2, 6, 3].should == acc
    res.should eql(@b)
  end
end

describe "#each_with_object" do
  before :each do
    @values = List[2, 5, 3, 6, 1, 4]
    @list = @values.dup
    @initial = "memo"
  end

  it "passes each element and its argument to the block" do
    acc = List[]
    @list.each_with_object(@initial) do |elem, obj|
      obj.should equal(@initial)
      obj = 42
      acc << elem
    end.should equal(@initial)
    acc.should == @values
  end

  it "returns an enumerator if no block" do
    acc = List[]
    e = @list.each_with_object(@initial)
    e.each do |elem, obj|
      obj.should equal(@initial)
      obj = 42
      acc << elem
    end.should equal(@initial)
    acc.should == @values
  end
end

describe "flat_map" do
  it "returns a new list with the results of passing each element to block, flattened one level" do
    list = List[1, List[2, 3], List[4, List[5, 6]], {:foo => :bar}]
    list.flat_map { |i| i }.should == List[1, 2, 3, 4, List[5, 6], {:foo => :bar}]
  end

  it "skips elements that are empty Lists" do
    list = List[1, List[], 2]
    list.flat_map { |i| i }.should == List[1, 2]
  end

  it "returns an enumerator when no block given" do
    enum = List[1, 2].flat_map
    enum.should be_an_instance_of(Enumerator)
    List[*enum] == List[1, 2]
  end
end

describe "#to_a" do
  it "returns an array containing the elements" do
    list = List[1, nil, 'a', 2, false, true]
    list.to_a.should == [1, nil, "a", 2, false, true]
  end

  it "returns a tainted array if self is tainted" do
    List[].taint.to_a.tainted?.should be_true
  end

  it "returns an untrusted array if self is untrusted" do
    List[].untrust.to_a.untrusted?.should be_true
  end
end

describe "#partition" do
  it "returns two lists" do
    List[].partition {}.should == List[List[], List[]]
  end

  it "returns in the left list values for which the block evaluates to true" do
    list = List[0, 1, 2, 3, 4, 5]

    list.partition { |i| true }.should == List[list, List[]]
    list.partition { |i| 5 }.should == List[list, List[]]
    list.partition { |i| false }.should == List[List[], list]
    list.partition { |i| nil }.should == List[List[], list]
    list.partition { |i| i % 2 == 0 }.should == List[List[0, 2, 4], List[1, 3, 5]]
    list.partition { |i| i / 3 == 0 }.should == List[List[0, 1, 2], List[3, 4, 5]]
  end

  it "properly handles recursive arrays" do
    empty = ListSpecs.empty_recursive_list
    empty.partition { true }.should == List[List[empty], List[]]
    empty.partition { false }.should == List[List[], List[empty]]

    list = ListSpecs.recursive_list
    list.partition { true }.should == List[
      List[1, 'two', 3.0, list, list, list, list, list],
      List[]
    ]
    condition = true
    list.partition { condition = !condition }.should == List[
      List['two', list, list, list],
      List[1, 3.0, list, list]
    ]
  end

  it "does not return subclass instances on Array subclasses" do
    result = ListSubclass[1, 2, 3].partition { |x| x % 2 == 0 }
    result.should be_an_instance_of(List)
    result[0].should be_an_instance_of(List)
    result[1].should be_an_instance_of(List)
  end
end

describe "none?" do
  it "returns true if none of the elements in self are true" do
    l = List[false, nil, false]
    l.none?.should be_true
  end

  it "returns false if at least one of the elements in self are true" do
    l = List[false, nil, true, false]
    l.none?.should be_false
  end

  before(:each) do
    @l = List[1,1,2,3,4]
  end

  it "passes each element to the block in turn until it returns true" do
    acc = []
    @l.none? {|e| acc << e; false }
    acc.should == [1,1,2,3,4]
  end

  it "stops passing elements to the block when it returns true" do
    acc = []
    @l.none? {|e| acc << e; e == 3 ? true : false }
    acc.should == [1,1,2,3]
  end

  it "returns true if the block never returns true" do
    @l.none? {|e| false }.should be_true
  end

  it "returns false if the block ever returns true" do
    @l.none? {|e| e == 3 ? true : false }.should be_false
  end
end

describe "#take_while" do
  before :each do
    @list = List[3, 2, 1, :go]
  end

  it "returns an Enumerator if no block given" do
    @list.take_while.should be_an_instance_of(Enumerator)
  end

  it "returns no/all elements for {true/false} block" do
    @list.take_while{true}.should == @list
    @list.take_while{false}.should == List[]
  end

  it "accepts returns other than true/false" do
    @list.take_while{1}.should == @list
    @list.take_while{nil}.should == List[]
  end

  it "passes elements to the block until the first false" do
    a = []
    @list.take_while{|obj| (a << obj).size < 3}.should == List[3, 2]
    a.should == [3, 2, 1]
  end

  it "will only go through what's needed" do
    list = List[4, 3, 2, 1, :stop]
    list.take_while { |x|
      break 42 if x == 3
      true
    }.should == 42
  end

  it "doesn't return self when it could" do
    l = List[1,2,3]
    l.take_while{true}.should_not equal(l)
  end

  it "returns all elements until the block returns false" do
    List[1, 2, 3].take_while{ |element| element < 3 }.should == List[1, 2]
  end

  it "returns all elements until the block returns nil" do
    List[1, 2, nil, 4].take_while{ |element| element }.should == List[1, 2]
  end

  it "returns all elements until the block returns false" do
    List[1, 2, false, 4].take_while{ |element| element }.should == List[1, 2]
  end
end

describe "#drop_while" do
  before :each do
    @list = List[3, 2, 1, :go]
  end

  it "returns an Enumerator if no block given" do
    @list.drop_while.should be_an_instance_of(Enumerator)
  end

  it "returns no/all elements for {true/false} block" do
    @list.drop_while{true}.should == List[]
    @list.drop_while{false}.should == @list
  end

  it "accepts returns other than true/false" do
    @list.drop_while{1}.should == List[]
    @list.drop_while{nil}.should == @list
  end

  it "passes elements to the block until the first false" do
    a = []
    @list.drop_while{|obj| (a << obj).size < 3}.should == List[1, :go]
    a.should == [3, 2, 1]
  end

  it "will only go through what's needed" do
    list = List[1,2,3,4]
    list.drop_while { |x|
      break 42 if x == 3
      true
    }.should == 42
  end

  it "doesn't return self when it could" do
    l = List[1,2,3]
    l.drop_while{false}.should_not equal(l)
  end

  it "removes elements from the start of the array while the block evaluates to true" do
    List[1, 2, 3, 4].drop_while { |n| n < 4 }.should == List[4]
  end

  it "removes elements from the start of the array until the block returns nil" do
    List[1, 2, 3, nil, 5].drop_while { |n| n }.should == List[nil, 5]
  end

  it "removes elements from the start of the array until the block returns false" do
    List[1, 2, 3, false, 5].drop_while { |n| n }.should == List[false, 5]
  end
end

describe "#find" do
  before :each do
    @elements = [2, 4, 6, 8, 10]
    @list = List[*@elements]
    @empty = List[]
  end

  it "passes each entry in list to block while block when block is false" do
    visited_elements = []
    @list.find do |element|
      visited_elements << element
      false
    end
    visited_elements.should == @elements
  end

  it "returns nil when the block is false and there is no ifnone proc given" do
    @list.find {|e| false }.should == nil
  end

  it "returns the first element for which the block is not false" do
    @elements.each do |element|
      @list.find {|e| e > element - 1 }.should == element
    end
  end

  it "returns the value of the ifnone proc if the block is false" do
    fail_proc = lambda { "cheeseburgers" }
    @list.find(fail_proc) {|e| false }.should == "cheeseburgers"
  end

  it "doesn't call the ifnone proc if an element is found" do
    fail_proc = lambda { raise "This shouldn't have been called" }
    @list.find(fail_proc) {|e| e == @elements.first }.should == 2
  end

  it "calls the ifnone proc only once when the block is false" do
    times = 0
    fail_proc = lambda { times += 1; raise if times > 1; "cheeseburgers" }
    @list.find(fail_proc) {|e| false }.should == "cheeseburgers"
  end

  it "calls the ifnone proc when there are no elements" do
    fail_proc = lambda { "yay" }
    List[].find(fail_proc) {|e| true}.should == "yay"
  end

  it "passes through the values yielded by #each_with_index" do
    visited_elements = []
    List[:a, :b].each_with_index.find { |x, i| visited_elements << [x, i]; nil }
    visited_elements.should == [[:a, 0], [:b, 1]]
  end

  it "returns an enumerator when no block given" do
    @list.find.should be_an_instance_of(Enumerator)
  end

  it "passes the ifnone proc to the enumerator" do
    times = 0
    fail_proc = lambda { times += 1; raise if times > 1; "cheeseburgers" }
    @list.find(fail_proc).each {|e| false }.should == "cheeseburgers"
  end
end

describe "#include?" do
  it "returns true if any element == argument for numbers" do
    class IncludeP; def ==(obj) obj == 5; end; end

    list = List[0,1,2,3,4,5]
    list.include?(5).should == true
    list.include?(10).should == false
    list.include?(IncludeP.new).should == true
  end

  it "returns true if any element == argument for other objects" do
    class IncludeP11; def ==(obj); obj == '11'; end; end
    list = List['0','1','2','3','4', '5', IncludeP11.new]
    list.include?('5').should == true
    list.include?('10').should == false
    list.include?(IncludeP11.new).should == true
    list.include?('11').should == true
  end

  it "calls == on elements from left to right until success" do
    key = "x"
    one = double('one')
    two = double('two')
    three = double('three')
    one.should_receive(:==).and_return(false)
    two.should_receive(:==).and_return(true)
    three.should_not_receive(:==)
    List[one, two, three].include?(key).should == true
  end
end

describe "#one?" do
  describe "when passed a block" do
    it "returns true if block returns true once" do
      List[:a, :b, :c].one? { |s| s == :a }.should be_true
    end

    it "returns false if the block returns true more than once" do
      List[:a, :b, :c].one? { |s| s == :a || s == :b }.should be_false
    end

    it "returns false if the block only returns false" do
      List[:a, :b, :c].one? { |s| s == :d }.should be_false
    end
  end

  describe "when not passed a block" do
    it "returns true if only one element evaluates to true" do
      List[false, nil, true].one?.should be_true
    end

    it "returns false if two elements evaluate to true" do
      List[false, :value, nil, true].one?.should be_false
    end

    it "returns false if all elements evaluate to false" do
      List[false, nil, false].one?.should be_false
    end
  end
end

describe "#find_index" do
  before :each do
    @elements = [2, 4, 6, 8, 10]
    @list = List[*@elements]
  end

  it "passes each entry in enum to block while block when block is false" do
    visited_elements = []
    @list.find_index do |element|
      visited_elements << element
      false
    end
    visited_elements.should == @elements
  end

  it "returns nil when the block is false" do
    @list.find_index {|e| false }.should == nil
  end

  it "returns the first index for which the block is not false" do
    @elements.each_with_index do |element, index|
      @list.find_index {|e| e > element - 1 }.should == index
    end
  end

  it "returns the first index found" do
    repeated = List[10, 11, 11, 13, 11, 13, 10, 10, 13, 11]
    numerous_repeat = repeated.dup
    repeated.each do |element|
      numerous_repeat.find_index(element).should == element - 10
    end
  end

  it "returns nil when the element not found" do
    @list.find_index(-1).should == nil
  end

  it "ignores the block if an argument is given" do
    @list.find_index(-1) {|e| true }.should == nil
  end

  it "returns an Enumerator if no block given" do
    @list.find_index.should be_an_instance_of(Enumerator)
  end
end

describe "#grep" do
  it "grep without a block should return a list of all elements === pattern" do
    class EnumerableSpecGrep; def ===(obj); obj == '2'; end; end

    List['2', 'a', 'nil', '3', false].grep(EnumerableSpecGrep.new).should == List['2']
  end

  it "grep with a block should return a list of elements === pattern passed through block" do
    class EnumerableSpecGrep2; def ===(obj); /^ca/ =~ obj; end; end
    list  = List["cat", "coat", "car", "cadr", "cost"]
    list.grep(EnumerableSpecGrep2.new) { |i| i.upcase }.should == List["CAT", "CAR", "CADR"]
  end

  it "grep the enumerable (rubycon legacy)" do
    List[].grep(1).should == List[]
    list = List[2, 4, 6, 8, 10]
    list.grep(3..7).should == List[4,6]
    list.grep(3..7) {|a| a+1}.should == List[5,7]
  end

  # TODO Can't figure out how to do this :(
  # it "can use $~ in the block when used with a Regexp" do
  #   List["aba", "aba"].grep(/a(b)a/) { $1 }.should == List["b", "b"]
  # end
end

describe "#reverse_each" do
  it "traverses list in reverse order and pass each element to block" do
    a = []
    List[2, 5, 3, 6, 1, 4].reverse_each { |i| a << i }
    a.should == [4, 1, 6, 3, 5, 2]
  end

  it "returns an Enumerator if no block given" do
    enum = List[2, 5, 3, 6, 1, 4].reverse_each
    enum.should be_an_instance_of(Enumerator)
    enum.to_a.should == [4, 1, 6, 3, 5, 2]
  end

  it "returns self" do
    l = List[:a, :b, :c]
    l.reverse_each { |x| }.should equal(l)
  end

  it "yields only the top level element of an empty recursive list" do
    a = []
    empty = ListSpecs.empty_recursive_list
    empty.reverse_each { |i| a << i }
    a.should == [empty]
  end

  it "yields only the top level element of a recursive list" do
    a = []
    list = ListSpecs.recursive_list
    list.reverse_each { |i| a << i }
    a.should == [list, list, list, list, list, 3.0, 'two', 1]
  end
end
