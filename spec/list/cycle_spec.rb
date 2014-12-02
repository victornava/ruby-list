require 'spec_helper'

describe "#cycle" do
  before :each do
    @acc = []
    @list = List[1, 2, 3]
    @lambda = lambda { |x| @acc << x }
  end

  it "does not yield and returns nil when the list is empty and passed value is an integer" do
    List[].cycle(6, &@lambda).should be_nil
    @acc.should == []
  end

  it "does not yield and returns nil when the list is empty and passed value is nil" do
    List[].cycle(nil, &@lambda).should be_nil
    @acc.should == []
  end

  it "does not yield and returns nil when passed 0" do
    @list.cycle(0, &@lambda).should be_nil
    @acc.should == []
  end

  it "iterates the list 'count' times yielding each item to the block" do
    @list.cycle(2, &@lambda)
    @acc.should == [1, 2, 3, 1, 2, 3]
  end

  it "iterates indefinitely when not passed a count" do
    @list.cycle do |x|
      @acc << x
      break if @acc.size > 7
    end
    @acc.should == [1, 2, 3, 1, 2, 3, 1, 2]
  end

  it "iterates indefinitely when passed nil" do
    @list.cycle(nil) do |x|
      @acc << x
      break if @acc.size > 7
    end
    @acc.should == [1, 2, 3, 1, 2, 3, 1, 2]
  end

  it "does not rescue StopIteration when not passed a count" do
    lambda do
      @list.cycle { raise StopIteration }
    end.should raise_error(StopIteration)
  end

  it "does not rescue StopIteration when passed a count" do
    lambda do
      @list.cycle(3) { raise StopIteration }
    end.should raise_error(StopIteration)
  end

  it "iterates the list Integer(count) times when passed a Float count" do
    @list.cycle(2.7, &@lambda)
    @acc.should == [1, 2, 3, 1, 2, 3]
  end

  it "calls #to_int to convert count to an Integer" do
    count = double("cycle count 2")
    count.should_receive(:to_int).and_return(2)

    @list.cycle(count, &@lambda)
    @acc.should == [1, 2, 3, 1, 2, 3]
  end

  it "raises a TypeError if #to_int does not return an Integer" do
    count = double("cycle count 2")
    count.should_receive(:to_int).and_return("2")

    lambda { @list.cycle(count, &@lambda) }.should raise_error(TypeError)
  end

  it "raises a TypeError if passed a String" do
    lambda { @list.cycle("4") { } }.should raise_error(TypeError)
  end

  it "raises a TypeError if passed an Object" do
    lambda { @list.cycle(double("cycle count")) { } }.should raise_error(TypeError)
  end

  it "raises a TypeError if passed true" do
    lambda { @list.cycle(true) { } }.should raise_error(TypeError)
  end

  it "raises a TypeError if passed false" do
    lambda { @list.cycle(false) { } }.should raise_error(TypeError)
  end
end