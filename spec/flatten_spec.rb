require 'spec_helper'

describe "#flatten" do
  it "returns a one-dimensional flattening recursively" do
    List[List[List[1, List[2, 3]],List[2, 3, List[4, List[4, List[5, 5]], List[1, 2, 3]]], List[4]], List[]].flatten.should == List[1, 2, 3, 2, 3, 4, 4, 5, 5, 1, 2, 3, 4]
  end

  it "takes an optional argument that determines the level of recursion" do
    List[ 1, 2, List[3, List[4, 5] ] ].flatten(1).should == List[1, 2, 3, List[4, 5]]
  end

  it "returns dup when the level of recursion is 0" do
    a = List[ 1, 2, List[3, List[4, 5] ] ]
    a.flatten(0).should == a
    a.flatten(0).should_not equal(a)
  end

  it "ignores negative levels" do
    List[ 1, 2, List[ 3, 4, List[5, 6] ] ].flatten(-1).should == List[1, 2, 3, 4, 5, 6]
    List[ 1, 2, List[ 3, 4, List[5, 6] ] ].flatten(-10).should == List[1, 2, 3, 4, 5, 6]
  end

  it "tries to convert passed Objects to Integers using #to_int" do
    obj = double("Converted to Integer")
    obj.should_receive(:to_int).and_return(1)

    List[ 1, 2, List[3, List[4, 5] ] ].flatten(obj).should == List[1, 2, 3, List[4, 5]]
  end

  it "raises a TypeError when the passed Object can't be converted to an Integer" do
    obj = double("Not converted")
    lambda { List[ 1, 2, List[3, List[4, 5] ] ].flatten(obj) }.should raise_error(TypeError)
  end

  it "returns subclass instance for List subclasses" do
    ListSubclass[].flatten.should be_an_instance_of(ListSubclass)
    ListSubclass[1, 2, 3].flatten.should be_an_instance_of(ListSubclass)
    ListSubclass[1, List[2], 3].flatten.should be_an_instance_of(ListSubclass)
    List[ListSubclass[1, 2, 3]].flatten.should be_an_instance_of(List)
  end

  it "is not destructive" do
    ary = List[1, List[2, 3]]
    ary.flatten
    ary.should == List[1, List[2, 3]]
  end
end