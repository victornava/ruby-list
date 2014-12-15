require 'spec_helper'

describe "#repeated_permutation" do

  before(:each) do
    @numbers = List[1, 2, 3]
    @permutations = [
      List[1, 1], List[1, 2], List[1, 3], List[2, 1], List[2, 2], List[2, 3], List[3, 1], List[3, 2], List[3, 3]
    ]
  end

  it "returns an Enumerator of all repeated permutations of given length when called without a block" do
    enum = @numbers.repeated_permutation(2)
    enum.should be_an_instance_of(Enumerator)
    enum.sort.should == @permutations
  end

  it "yields all repeated_permutations to the block then returns self when called with block but no arguments" do
    yielded = []
    @numbers.repeated_permutation(2) {|n| yielded << n}.should equal(@numbers)
    yielded.sort.should == @permutations
  end

  it "yields the empty repeated_permutation ([[]]) when the given length is 0" do
    @numbers.repeated_permutation(0).to_a.should == [List[]]
    List[].repeated_permutation(0).to_a.should == [List[]]
  end

  it "does not yield when called on an empty Array with a nonzero argument" do
    List[].repeated_permutation(1).to_a.should == []
  end

  it "handles duplicate elements correctly" do
    @numbers[-1] = 1
    @numbers.repeated_permutation(2).sort.should ==
    [List[1, 1], List[1, 1], List[1, 1], List[1, 1], List[1, 2], List[1, 2], List[2, 1], List[2, 1], List[2, 2]]
  end

  it "truncates Float arguments" do
    @numbers.repeated_permutation(3.7).to_a.sort.should ==
      @numbers.repeated_permutation(3).to_a.sort
  end

  it "allows permutations larger than the number of elements" do
    List[1,2].repeated_permutation(3).sort.should == [
      List[1, 1, 1], List[1, 1, 2], List[1, 2, 1],
      List[1, 2, 2], List[2, 1, 1], List[2, 1, 2],
      List[2, 2, 1], List[2, 2, 2]
    ]
  end

  it "returns an empty enumerator when length is negative " do
    enum = List[1,2].repeated_permutation(-1)
    enum.should be_an_instance_of(Enumerator)
    enum.to_a.should == []
  end
end
