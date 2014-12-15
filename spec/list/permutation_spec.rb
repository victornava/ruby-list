require 'spec_helper'

describe "#permutation" do
  before(:each) do
    @numbers = List[1, 2, 3]
    @yielded = []
  end

  it "returns an Enumerator of all permutations when called without a block or arguments" do
    enum = @numbers.permutation
    enum.should be_an_instance_of(Enumerator)
    enum.to_a.sort.should == [
      List[1,2,3], List[1,3,2], List[2,1,3], List[2,3,1], List[3,1,2], List[3,2,1]
    ].sort
  end

  it "returns an Enumerator of all permutations when called without a block or arguments" do
    enum = @numbers.permutation
    enum.should be_an_instance_of(Enumerator)
    enum.to_a.sort.should == [
      List[1,2,3], List[1,3,2], List[2,1,3], List[2,3,1], List[3,1,2], List[3,2,1]
    ].sort
  end

  it "returns an Enumerator of permutations of given length when called with an argument but no block" do
    enum = @numbers.permutation(1)
    enum.should be_an_instance_of(Enumerator)
    enum.to_a.sort.should == [List[1], List[2], List[3]]
  end

  it "yields all permutations to the block then returns self when called with block but no arguments" do
    list = @numbers.permutation {|n| @yielded << n}
    list.should be_an_instance_of(List)
    list.sort.should == @numbers.sort
    @yielded.sort.should == [
      List[1,2,3], List[1,3,2], List[2,1,3], List[2,3,1], List[3,1,2], List[3,2,1]
    ].sort
  end

  it "yields all permutations of given length to the block then returns self when called with block and argument" do
    list = @numbers.permutation(2) {|n| @yielded << n}
    list.should be_an_instance_of(List)
    list.sort.should == @numbers.sort
    @yielded.sort.should == [List[1,2],List[1,3],List[2,1],List[2,3],List[3,1],List[3,2]].sort
  end

  it "returns the empty permutation (List[List[]]) when the given length is 0" do
    @numbers.permutation(0).to_a.should == [List[]]
    @numbers.permutation(0) { |n| @yielded << n }
    @yielded.should == [List[]]
  end

  it "returns the empty permutation(List[]) when called on an empty List" do
    List[].permutation.to_a.should == [List[]]
    List[].permutation { |n| @yielded << n }
    @yielded.should == [List[]]
  end

  it "returns no permutations when the given length has no permutations" do
    @numbers.permutation(9).entries.size == 0
    @numbers.permutation(9) { |n| @yielded << n }
    @yielded.should == []
  end

  it "truncates Float arguments" do
    @numbers.permutation(3.7).to_a.sort.should ==
      @numbers.permutation(3).to_a.sort
  end
end
