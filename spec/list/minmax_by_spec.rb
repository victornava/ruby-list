require 'spec_helper'

describe "#minmax_by" do
  it "returns an enumerator if no block" do
    List[42].minmax_by.should be_an_instance_of(Enumerator)
  end

  it "returns nil if #each yields no objects" do
    List[].minmax_by {|o| o.nonesuch }.should == List[nil, nil]
  end

  it "returns the object for whom the value returned by block is the largest" do
    List['1', '2', '3'].minmax_by {|obj| obj.to_i }.should == List['1', '3']
    List['three', 'five'].minmax_by {|obj| obj.size }.should == List['five', 'three']
  end

  it "returns the object that appears first in #each in case of a tie" do
    a, b, c, d = '1', '1', '2', '2'
    mm = List[a, b, c, d].minmax_by {|obj| obj.to_i }
    mm[0].should equal(a)
    mm[1].should equal(c)
  end

  it "uses min/max.<=>(current) to determine order" do
    a, b, c = (1..3).map{|n| ReverseComparable.new(n)}

    # Just using self here to avoid additional complexity
    List[a, b, c].minmax_by {|obj| obj }.should == List[c, a]
  end

  it "is able to return the maximum for enums that contain nils" do
    list = List[nil, nil, true]
    list.minmax_by {|o| o.nil? ? 0 : 1 }.should == List[nil, true]
  end
end
