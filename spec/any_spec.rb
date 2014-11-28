require 'spec_helper'

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

