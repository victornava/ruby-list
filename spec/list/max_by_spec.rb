require 'spec_helper'

describe "#max_by" do
  it "returns an enumerator if no block" do
    List[42].max_by.should be_an_instance_of(Enumerator)
  end

  it "returns nil if #each yields no objects" do
    List[].max_by {|o| o.nonesuch }.should == nil
  end

  it "returns the object for whom the value returned by block is the largest" do
    List['1', '2', '3'].max_by {|obj| obj.to_i }.should == '3'
    List['three', 'five'].max_by {|obj| obj.size }.should == 'three'
  end

  it "returns the object that appears first in #each in case of a tie" do
    a, b, c = '1', '2', '2'
    List[a, b, c].max_by {|obj| obj.to_i }.should equal(b)
  end

  it "uses max.<=>(current) to determine order" do
    a, b, c = (1..3).map{|n| ReverseComparable.new(n)}

    # Just using self here to avoid additional complexity
    List[a, b, c].max_by {|obj| obj }.should == a
  end

  it "is able to return the maximum for enums that contain nils" do
    list = List[nil, nil, true]
    list.max_by {|o| o.nil? ? 0 : 1 }.should == true
    list.max_by {|o| o.nil? ? 1 : 0 }.should == nil
  end
end
