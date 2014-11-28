require 'spec_helper'

describe "#min_by" do
  it "returns an enumerator if no block" do
    List[42].min_by.should be_an_instance_of(Enumerator)
  end

  it "returns nil if #each yields no objects" do
    List[].min_by {|o| o.nonesuch }.should == nil
  end

  it "returns the object for whom the value returned by block is the largest" do
    List['3', '2', '1'].min_by {|obj| obj.to_i }.should == '1'
    List['five', 'three'].min_by {|obj| obj.size }.should == 'five'
  end

  it "returns the object that appears first in #each in case of a tie" do
    a, b, c = '2', '1', '1'
    List[a, b, c].min_by {|obj| obj.to_i }.should equal(b)
  end

  it "uses min.<=>(current) to determine order" do
    a, b, c = (1..3).map{|n| ReverseComparable.new(n)}

    # Just using self here to avoid additional complexity
    List[a, b, c].min_by {|obj| obj }.should == c
  end

  it "is able to return the maximum for enums that contain nils" do
    list = List[nil, nil, true]
    list.min_by {|o| o.nil? ? 0 : 1 }.should == nil
    list.min_by {|o| o.nil? ? 1 : 0 }.should == true
  end
end


