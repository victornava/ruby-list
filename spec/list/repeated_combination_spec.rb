require 'spec_helper'

describe "#repeated_combination" do
  before :each do
    @list = List[0, 1, 2]
  end

  it "returns an enumerator when no block is provided" do
    @list.repeated_combination(2).should be_an_instance_of(Enumerator)
  end

  it "returns self when a block is given" do
    @list.repeated_combination(2){}.should equal(@list)
  end

  it "yields nothing for negative length and return self" do
    @list.repeated_combination(-1){ fail }.should equal(@list)
  end

  it "yields the expected repeated_combinations" do
    @list.repeated_combination(2).to_a.sort.should == [
      List[0, 0], List[0, 1], List[0, 2], List[1, 1], List[1, 2], List[2, 2]
    ]

    @list.repeated_combination(3).to_a.sort.should == [
      List[0, 0, 0], List[0, 0, 1], List[0, 0, 2], List[0, 1, 1], List[0, 1, 2],
      List[0, 2, 2], List[1, 1, 1], List[1, 1, 2], List[1, 2, 2], List[2, 2, 2]
    ]
  end

  it "yields [] when length is 0" do
    @list.repeated_combination(0).to_a.should == [[]] # one repeated_combination of length 0
    List[].repeated_combination(0).to_a.should == [[]] # one repeated_combination of length 0
  end

  it "yields nothing when the list is empty and num is non zero" do
    List[].repeated_combination(5).to_a.should == [] # one repeated_combination of length 0
  end

  it "yields a partition consisting of only singletons" do
    @list.repeated_combination(1).sort.to_a.should == [List[0], List[1], List[2]]
  end

  it "accepts sizes larger than the original list" do
    @list.repeated_combination(4).to_a.sort.should ==
      [List[0, 0, 0, 0], List[0, 0, 0, 1], List[0, 0, 0, 2],
       List[0, 0, 1, 1], List[0, 0, 1, 2], List[0, 0, 2, 2],
       List[0, 1, 1, 1], List[0, 1, 1, 2], List[0, 1, 2, 2],
       List[0, 2, 2, 2], List[1, 1, 1, 1], List[1, 1, 1, 2],
       List[1, 1, 2, 2], List[1, 2, 2, 2], List[2, 2, 2, 2]]
  end

  it "generates from a defensive copy, ignoring mutations" do
    acc = []
    @list.repeated_combination(2) do |x|
      acc << x
      @list[0] = 1
    end
    acc.sort.should == [List[0, 0], List[0, 1], List[0, 2], List[1, 1], List[1, 2], List[2, 2]]
  end
end
