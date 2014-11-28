require 'spec_helper'

describe "#compact" do
  it "returns a copy of list with all nil elements removed" do
    l = List[1, 2, 4]
    l.compact.should == List[1, 2, 4]
    l = List[1, nil, 2, 4]
    l.compact.should == List[1, 2, 4]
    l = List[1, 2, 4, nil]
    l.compact.should == List[1, 2, 4]
    l = List[nil, 1, 2, 4]
    l.compact.should == List[1, 2, 4]
  end

  it "does not return self" do
    l = List[1, 2, 3]
    l.compact.should_not equal(l)
  end

  it "does not return subclass instance for List subclasses" do
    ListSubclass[1, 2, 3, nil].compact.should be_an_instance_of(List)
  end

  it "does not keep tainted status even if all elements are removed" do
    l = List[nil, nil]
    l.taint
    l.compact.tainted?.should be_false
  end

  it "does not keep untrusted status even if all elements are removed" do
    l = List[nil, nil]
    l.untrust
    l.compact.untrusted?.should be_false
  end
end