require 'spec_helper'

describe "#sort_by" do
  it "returns an array of elements ordered by the result of block" do
    l = List["once", "upon", "a", "time"]
    l.sort_by { |i| i[0] }.should == List["a", "once", "time", "upon"]
  end

  it "sorts the object by the given attribute" do
    class Dummy
      def initialize(s) ; @s = s ; end
      def s ; @s ; end
    end

    a = Dummy.new("fooo")
    b = Dummy.new("bar")

    ar = List[a, b].sort_by { |d| d.s }
    ar.should ==List[b, a]
  end

  it "returns an Enumerator when a block is not supplied" do
    l = List["a","b"]
    l.sort_by.should be_an_instance_of(Enumerator)
  end
end
