require 'spec_helper'

describe "#take" do
  before :each do
    @list = List[4,3,2,1,0,-1]
  end

  it "returns the first count elements if given a count" do
    @list.take(2).should == List[4, 3]
    @list.take(4).should == List[4, 3, 2, 1]
  end

  it "returns an empty List when passed count on an empty List" do
    empty = List[]
    empty.take(0).should == empty
    empty.take(1).should == empty
    empty.take(2).should == empty
  end

  it "returns an empty List when passed count == 0" do
    @list.take(0).should == List[]
  end

  it "returns an List containing the first element when passed count == 1" do
    @list.take(1).should.should == List[4]
  end

  it "raises an ArgumentError when count is negative" do
    lambda { @list.take(-1) }.should raise_error(ArgumentError)
  end

  it "returns the entire List when count > size" do
    @list.take(100).should == @list
    @list.take(8).should == @list
  end

  it "raises a TypeError if the passed argument is not numeric" do
    lambda { @list.take(nil) }.should raise_error(TypeError)
    lambda { @list.take("a") }.should raise_error(TypeError)

    obj = double("nonnumeric")
    lambda { @list.send(@method, obj) }.should raise_error(TypeError)
  end
end


