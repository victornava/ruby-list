require 'spec_helper'

describe "#empty?" do
  it "returns true if the list has no elements" do
    List[].empty?.should == true
    List[1].empty?.should == false
    List[1, 2].empty?.should == false
  end
end