require 'spec_helper'

describe "#to_a" do
  it "returns an array containing the elements" do
    list = List[1, nil, 'a', 2, false, true]
    list.to_a.should == [1, nil, "a", 2, false, true]
  end

  it "returns a tainted array if self is tainted" do
    List[].taint.to_a.tainted?.should be_true
  end

  it "returns an untrusted array if self is untrusted" do
    List[].untrust.to_a.untrusted?.should be_true
  end
end
