require 'spec_helper'

describe "#|" do
  it "returns a list of elements that appear in either list (union)" do
    (List[] | List[]).should == List[]
    (List[1, 2] | List[]).should == List[1, 2]
    (List[] | List[1, 2]).should == List[1, 2]
    (List[ 1, 2, 3, 4 ] | List[ 3, 4, 5 ]).should == List[1, 2, 3, 4, 5]
  end

  it "creates a list with no duplicates" do
    (List[ 1, 2, 3, 1, 4, 5 ] | List[ 1, 3, 4, 5, 3, 6 ]).should == List[1, 2, 3, 4, 5, 6]
  end

  it "creates a list with elements in order they are first encountered" do
    (List[ 1, 2, 3, 1 ] | List[ 1, 3, 4, 5 ]).should == List[1, 2, 3, 4, 5]
  end

  # MRI follows hashing semantics here, so doesn't actually call eql?/hash for Fixnum/Symbol
  it "acts as if using an intermediate hash to collect values" do
    (List[5.0, 4.0] | List[5, 4]).should == List[5.0, 4.0, 5, 4]
    (List["x"] | List["x"]).should == List["x"]
  end

  it "does not return subclass instances for List subclasses" do
    (ListSubclass[1, 2, 3] | List[]).should be_an_instance_of(List)
    (ListSubclass[1, 2, 3] | ListSubclass[1, 2, 3]).should be_an_instance_of(List)
    (List[] | ListSubclass[1, 2, 3]).should be_an_instance_of(List)
  end
end
