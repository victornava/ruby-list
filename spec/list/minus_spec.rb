require 'spec_helper'

describe "#-" do
  it "creates an list minus any items from other list" do
    (List[] - List[ 1, 2, 4 ]).should == List[]
    (List[1, 2, 4] - List[]).should == List[1, 2, 4]
    (List[ 1, 2, 3, 4, 5 ] - List[ 1, 2, 4 ]).should == List[3, 5]
  end

  it "removes multiple items on the lhs equal to one on the rhs" do
    (List[1, 1, 2, 2, 3, 3, 4, 5] - List[1, 2, 4]).should == List[3, 3, 5]
  end

  it "does not return subclass instance for List subclasses" do
    (ListSubclass[1, 2, 3] - List[]).should be_an_instance_of(List)
    (ListSubclass[1, 2, 3] - ListSubclass[]).should be_an_instance_of(List)
    (List[1, 2, 3] - ListSubclass[]).should be_an_instance_of(List)
  end

  it "is not destructive" do
    l = List[1, 2, 3]
    l - List[]
    l.should == List[1, 2, 3]
    l - List[1]
    l.should == List[1, 2, 3]
    l - List[1,2,3]
    l.should == List[1, 2, 3]
    l - List[:a, :b, :c]
    l.should == List[1, 2, 3]
  end

  it "raises TypeError if other is not a List" do
    lambda { List[] - "" }.should raise_error(TypeError)
  end
end
