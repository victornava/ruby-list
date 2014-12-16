require 'spec_helper'

describe "List.new" do
  it "returns an instance of List" do
    List.new.should be_an_instance_of(List)
  end

  it "returns an instance of a subclass" do
    ListSubclass.new(1, 2).should be_an_instance_of(ListSubclass)
  end
end

describe "List.new with no arguments" do
  it "returns an empty list" do
    List.new.should be_empty
  end

  it "does not use the given block" do
    lambda{ List.new { raise } }.should_not raise_error
  end
end

describe "List.new with (list)" do
  it "returns an list initialized to the other list" do
    l = List[4, 5, 6]
    List.new(l).should == l
  end

  it "does not use the given block" do
    lambda{ List.new([1, 2]) { raise } }.should_not raise_error
  end

  it "raises a TypeError if an List type argument and a default object" do
    lambda { List.new([1, 2], 1) }.should raise_error(TypeError)
  end
end

describe "List.new with (size, object=nil)" do
  it "returns an list of size filled with object" do
    obj = [3]
    l = List.new(2, obj)
    l.should == List[obj, obj]
    l[0].should equal(obj)
    l[1].should equal(obj)
  end

  it "returns an list of size filled with nil when object is omitted" do
    List.new(3).should == List[nil, nil, nil]
  end

  it "raises an ArgumentError if size is negative" do
    lambda { List.new(-1, :a) }.should raise_error(ArgumentError)
    lambda { List.new(-1) }.should raise_error(ArgumentError)
  end

  it "calls #to_int to convert the size argument to an Integer when object is given" do
    obj = double('1')
    obj.should_receive(:to_int).and_return(1)
    List.new(obj, :a).should == List[:a]
  end

  it "calls #to_int to convert the size argument to an Integer when object is not given" do
    obj = double('1')
    obj.should_receive(:to_int).and_return(1)
    List.new(obj).should == List[nil]
  end

  it "raises a TypeError if the size argument is not an Integer type" do
    obj = double('nonnumeric')
    obj.stub(:to_ary).and_return([1, 2])
    lambda{ List.new(obj, :a) }.should raise_error(TypeError)
  end

  it "yields the index of the element and sets the element to the value of the block" do
    List.new(3) { |i| i.to_s }.should == List['0', '1', '2']
  end

  it "uses the block value instead of using the default value" do
    List.new(3, :obj) { |i| i.to_s }.should == List['0', '1', '2']
  end

  it "returns the value passed to break" do
    l = List.new(3) do |i|
      break if i == 2
      i.to_s
    end

    l.should == nil
  end
end