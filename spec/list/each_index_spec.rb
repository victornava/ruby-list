require 'spec_helper'

describe "#each_index" do

  it "passes the index of each element to the block" do
    l = List['a', 'b', 'c', 'd']
    acc = List[]
    l.each_index { |i| acc << i }
    acc.should == List[0, 1, 2, 3]
  end

  it "returns self" do
    l = List[:a, :b, :c]
    l.each_index { |i| }.should equal(l)
  end

  it "returns an Enumerator if no block given" do
    List[1, 2].each_index.should be_an_instance_of(Enumerator)
    List[1, 2].each_index.to_a.should == [0, 1]
  end
end
