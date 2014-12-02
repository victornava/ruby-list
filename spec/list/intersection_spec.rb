require 'spec_helper'

describe "#&" do
  it "creates a list with elements common to both arrays (intersection)" do
    (List[] & List[]).should == List[]
    (List[1, 2] & List[]).should == List[]
    (List[] & List[1, 2]).should == List[]
    (List[ 1, 3, 5 ] & List[ 1, 2, 3 ]).should == List[1, 3]
  end

  it "creates a list with no duplicates" do
    (List[ 1, 1, 3, 5 ] & List[ 1, 2, 3 ]).should == List[1, 3]
  end

  it "creates a list with elements in order they are first encountered" do
    (List[ 1, 2, 3, 2, 5 ] & List[ 5, 2, 3, 4 ]).should == List[2, 3, 5]
  end

  it "does not modify the original list" do
    l = List[1, 1, 3, 5]
    l & List[1, 2, 3]
    l.should == List[1, 1, 3, 5]
  end

  it "determines equivalence between elements in the sense of eql?" do
    (List[5.0, 4.0] & List[5, 4]).should == List[]
    (List["x"] & List["x"]).should == List["x"]
  end

  it "does not return subclass instances for List subclasses" do
    (ListSubclass[1, 2, 3] & List[]).should be_an_instance_of(List)
    (ListSubclass[1, 2, 3] & ListSubclass[1, 2, 3]).should be_an_instance_of(List)
    (List[] & ListSubclass[1, 2, 3]).should be_an_instance_of(List)
  end

  it "does not call to_ary on array subclasses" do
    (List[5, 6] & ListSubclass[1, 2, 5, 6]).should == List[5, 6]
  end

  it "raises TypeError if the other is not a List" do
    lambda { List[5, 6] & "" }.should raise_error(TypeError)
  end
end
