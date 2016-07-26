require 'spec_helper'

describe "#chunk_while" do

  before :each do
    @list = List[10, 9, 7, 6, 4, 3, 2, 1]
    @result = @list.chunk_while { |i, j| i - 1 == j }
  end

  context "when given a block" do
    it "returns an enumerator" do
      @result.should be_an_instance_of(Enumerator)
    end

    it "splits chunks between adjacent elements i and j where the block returns false" do
      @result.to_a.should == List[List[10, 9], List[7, 6], List[4, 3, 2, 1]]
    end

    it "calls the block for length of the receiver enumerable minus one times" do
      times_called = 0
      @list.chunk_while do |i, j|
        times_called += 1
        i - 1 != j
      end.to_a
      times_called.should == (@list.size - 1)
    end
  end

  context "when not given a block" do
    it "raises an ArgumentError" do
      lambda { @list.chunk_while }.should raise_error(ArgumentError)
    end
  end
end