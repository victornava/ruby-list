require 'spec_helper'

describe "#size" do
  it "returns the number of elements" do
    List[].size.should == 0
    List[1, 2, 3].size.should == 3
  end

  it "properly handles recursive Lists" do
    ListSpecs.empty_recursive_list.size.should == 1
    ListSpecs.recursive_list.size.should == 8
  end
end

