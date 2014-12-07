require 'spec_helper'

describe "#combination" do
  before :each do
    @list = List[1, 2, 3, 4]
  end

  it "returns an enumerator when no block is provided" do
    @list.combination(2).should be_an_instance_of(Enumerator)
  end

  it "returns self when a block is given" do
    @list.combination(2){}.should equal(@list)
  end

  it "yields nothing for out of bounds length and return self" do
    List[*@list.combination(5)].should == List[]
    List[*@list.combination(-1)].should == List[]
  end

  it "yields the expected combinations" do
    @list.combination(3).to_a.sort.should == [[1,2,3],[1,2,4],[1,3,4],[2,3,4]]
  end

  it "yields nothing if the argument is out of bounds" do
    @list.combination(-1).to_a.should == []
    @list.combination(5).to_a.should == []
  end

  it "yields a copy of self if the argument is the size of the receiver" do
    r = @list.combination(4).to_a
    r.should == [@list.to_a]
    r[0].should_not equal(@list.to_a)
  end

  it "yields [] when length is 0" do
    @list.combination(0).to_a.should == [[]] # one combination of length 0
    [].combination(0).to_a.should == [[]] # one combination of length 0
  end

  it "yields a partition consisting of only singletons" do
    @list.combination(1).to_a.sort.should == [[1],[2],[3],[4]]
  end
end