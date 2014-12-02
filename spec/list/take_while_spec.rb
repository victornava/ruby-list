require 'spec_helper'

describe "none?" do
  it "returns true if none of the elements in self are true" do
    l = List[false, nil, false]
    l.none?.should be_true
  end

  it "returns false if at least one of the elements in self are true" do
    l = List[false, nil, true, false]
    l.none?.should be_false
  end

  before(:each) do
    @l = List[1,1,2,3,4]
  end

  it "passes each element to the block in turn until it returns true" do
    acc = []
    @l.none? {|e| acc << e; false }
    acc.should == [1,1,2,3,4]
  end

  it "stops passing elements to the block when it returns true" do
    acc = []
    @l.none? {|e| acc << e; e == 3 ? true : false }
    acc.should == [1,1,2,3]
  end

  it "returns true if the block never returns true" do
    @l.none? {|e| false }.should be_true
  end

  it "returns false if the block ever returns true" do
    @l.none? {|e| e == 3 ? true : false }.should be_false
  end
end
