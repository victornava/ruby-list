require 'spec_helper'

describe "#last" do
  it "returns the last element" do
    List[1, 1, 1, 1, 2].last.should == 2
  end

  it "returns nil if self is empty" do
    List[].last.should == nil
  end

  it "returns the last count elements if given a count" do
    List[1, 2, 3, 4, 5, 9].last(3).should == List[4, 5, 9]
  end

  it "returns an empty list when passed a count on an empty list" do
    List[].last(0).should == List[]
    List[].last(1).should == List[]
  end

  it "returns an empty list when count == 0" do
    List[1, 2, 3, 4, 5].last(0).should == List[]
  end

  it "returns an list containing the last element when passed count == 1" do
    List[1, 2, 3, 4, 5].last(1).should == List[5]
  end

  it "raises an ArgumentError when count is negative" do
    lambda { List[1, 2].last(-1) }.should raise_error(ArgumentError)
  end

  it "returns the entire list when count > length" do
    List[1, 2, 3, 4, 5, 9].last(10).should == List[1, 2, 3, 4, 5, 9]
  end

  it "properly handles recursive lists" do
    empty = ListSpecs.empty_recursive_list
    empty.last.should equal(empty)

    list = ListSpecs.recursive_list
    list.last.should equal(list)
  end

  it "raises a TypeError if the passed argument is not numeric" do
    lambda { List[1,2].last(nil) }.should raise_error(TypeError)
    lambda { List[1,2].last("a") }.should raise_error(TypeError)

    obj = double("nonnumeric")
    lambda { List[1,2].last(obj) }.should raise_error(TypeError)
  end

  it "does not return subclass instance on List subclasses" do
    ListSubclass[].last(0).should be_an_instance_of(List)
    ListSubclass[].last(2).should be_an_instance_of(List)
    ListSubclass[1, 2, 3].last(0).should be_an_instance_of(List)
    ListSubclass[1, 2, 3].last(1).should be_an_instance_of(List)
    ListSubclass[1, 2, 3].last(2).should be_an_instance_of(List)
  end

  it "is not destructive" do
    list = List[1, 2, 3]
    list.last
    list.should == List[1, 2, 3]
  end
end