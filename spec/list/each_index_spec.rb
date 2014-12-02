require 'spec_helper'

describe "#each_index" do

  it "passes the index of each element to the block" do
    l = ['a', 'b', 'c', 'd']
    acc = List[]
    l.each_index { |i| acc << i }
    acc.should == List[0, 1, 2, 3]
  end

  it "returns self" do
    l = List[:a, :b, :c]
    l.each_index { |i| }.should equal(l)
  end

  it "returns an Enumerator if no block given" do
    [1,2].each_index.should be_an_instance_of(Enumerator)
  end
end
