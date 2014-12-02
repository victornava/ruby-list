require 'spec_helper'

describe "#minmax" do
  before :each do
    @list = List[6, 4, 5, 10, 8]
    @strs = List["333", "2", "60", "55555", "1010", "111"]
  end

  it "min should return the minimum element" do
    @list.minmax.should == List[4, 10]
    @strs.minmax.should == List["1010", "60"]
  end

  it "returns [nil, nil] for an empty List" do
    List[].minmax.should == List[nil, nil]
  end

  it "raises an ArgumentError when elements are incomparable" do
    lambda do
      List[11,"22"].minmax
    end.should raise_error(ArgumentError)

    lambda do
      List[11,12,22,33].minmax{|a, b| nil}
    end.should raise_error(ArgumentError)
  end

  it "raises a NoMethodError for elements without #<=>" do
    lambda do
      List[Object.new, Object.new].minmax
    end.should raise_error(NoMethodError)
  end

  it "returns the minimum when using a block rule" do
    @list.minmax {|a,b| b <=> a }.should == List[10, 4]
    @strs.minmax {|a,b| a.size <=> b.size }.should == List["2", "55555"]
  end
end
