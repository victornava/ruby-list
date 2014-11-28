require 'spec_helper'

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

  it "returns the entire List when count > size" do
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


