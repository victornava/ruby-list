require 'spec_helper'

describe "::[]" do
  it "returns a new list populated with the given elements" do
    obj = Object.new
    List[5, true, nil, 'a', "Ruby", obj]._array.should == [5, true, nil, "a", "Ruby", obj]
  end
end

describe "#[]" do
  it "delegates to Array" do
    List[0,1,2][1].should == 1
  end
end

describe "#each" do
  it "delegates to Array" do
    List[1,2].each.inspect.should  == [1,2].each.inspect
  end
end

describe "#==" do
  it "delegates to Array" do
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
    a = Array[1, 2, 3]
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

  it "returns a new array of elements for which block is true" do
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

    class DodgyList < List
      def each
        raise "need more babarabatiri!"
      end
    end

    lambda {
      DodgyList[1].all?
    }.should raise_error(RuntimeError)

    lambda {
      DodgyList[1].all? { false }
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