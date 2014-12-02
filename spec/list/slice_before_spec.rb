require 'spec_helper'

describe "#slice_before" do

  before :each do
    @list = List[7,6,5,4,3,2,1]
  end

  describe "when given an argument and no block" do
    it "calls === on the argument to determine when to yield" do
      arg = double("filter")
      arg.should_receive(:===).and_return(false, true, false, false, false, true, false)
      enum = @list.slice_before(arg)
      enum.should be_an_instance_of(Enumerator)
      enum.to_a.should == [List[7], List[6, 5, 4, 3], List[2, 1]]
    end

    it "doesn't yield an empty array if the filter matches the first entry or the last entry" do
      arg = double("filter")
      arg.should_receive(:===).and_return(true, true, true, true, true, true, true)
      enum = @list.slice_before(arg)
      enum.to_a.should == [List[7], List[6], List[5], List[4], List[3], List[2], List[1]]
    end

    it "uses standard boolean as a test" do
      arg = double("filter")
      arg.should_receive(:===).and_return(false, true, false, false, false, true, false)
      # arg.should_receive(:===).and_return(false, :foo, nil, false, false, 42, false)
      enum = @list.slice_before(arg)
      enum.to_a.should == [List[7], List[6, 5, 4, 3], List[2, 1]]
    end
  end

  describe "when given a block and no argument" do
    it "calls the block to determine when to yield" do
      enum = @list.slice_before{|i| i == 6 || i == 2}
      enum.should be_an_instance_of(Enumerator)
      enum.to_a.should == [List[7], List[6, 5, 4, 3], List[2, 1]]
    end
  end

  describe "when given a block and an argument" do
    it "calls the block with a copy of that argument" do
      arg = [:foo]
      first = nil
      enum = @list.slice_before(arg) do |i, init|
        init.should == arg
        init.should_not equal(arg)
        first = init
        i == 6 || i == 2
      end
      enum.should be_an_instance_of(Enumerator)
      enum.to_a.should == [List[7], List[6, 5, 4, 3], List[2, 1]]
      enum = @list.slice_before(arg) do |i, init|
        init.should_not equal(first)
      end
    end
  end

  it "raises an Argument error when given an incorrect number of arguments" do
    lambda { @list.slice_before("one", "two") }.should raise_error(ArgumentError)
    lambda { @list.slice_before }.should raise_error(ArgumentError)
  end
end