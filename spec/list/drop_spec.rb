require 'spec_helper'

describe "#drop" do
  it "removes the specified number of elements from the start of the List" do
    List[1, 2, 3, 4, 5].drop(2).should == List[3, 4, 5]
  end

  it "raises an ArgumentError if the number of elements specified is negative" do
    lambda { List[1, 2].drop(-3) }.should raise_error(ArgumentError)
  end

  it "returns an empty List if all elements are dropped" do
    List[1, 2].drop(2).should == List[]
  end

  it "returns an empty List when called on an empty List" do
    List[].drop(0).should == List[]
  end

  it "does not remove any elements when passed zero" do
    List[1, 2].drop(0).should == List[1, 2]
  end

  it "returns an empty List if more elements than exist are dropped" do
    List[1, 2].drop(3).should == List[]
  end
end


