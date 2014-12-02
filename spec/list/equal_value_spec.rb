require 'spec_helper'

describe "#==" do
  it "delegates to Array" do
    List[1,2].should == List[1,2]
  end
end