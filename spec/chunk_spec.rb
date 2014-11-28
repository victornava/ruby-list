require 'spec_helper'

describe "#chunk" do

  it "raises an ArgumentError if called without a block" do
    lambda do
      List[].chunk
    end.should raise_error(ArgumentError)
  end

  it "returns an Enumerator if given a block" do
    List[].chunk {}.should be_an_instance_of(Enumerator)
  end

  it "yields the current element and the current chunk to the block" do
    acc = []
    list = List[1, 2, 3]
    list.chunk { |x| acc << x }.to_a
    acc.should == [1, 2, 3]
  end

  it "returns elements of the Enumerable in an List of List, [v, ary], where 'ary' contains the consecutive elements for which the block returned the value 'v'" do
    list = List[1, 2, 3, 2, 3, 2, 1]
    result = list.chunk { |x| x < 3 ? :yes : :no }.to_a
    result.should == [List[:yes, List[1, 2]], List[:no, List[3]], List[:yes, List[2]], List[:no, List[3]], List[:yes, List[2, 1]]]
  end

  it "returns elements for which the block returns :_alone in separate Arrays" do
    list = List[1, 2, 3, 2, 1]
    result = list.chunk { |x| x < 2 && :_alone }.to_a
    result.should == [List[:_alone, List[1]], List[false, List[2, 3, 2]], List[:_alone, List[1]]]
  end

  it "does not return elements for which the block returns :_separator" do
    list = List[1, 2, 3, 3, 2, 1]
    result = list.chunk { |x| x == 2 ? :_separator : 1 }.to_a
    result.should == [List[1, List[1]], List[1, List[3, 3]], List[1, List[1]]]
  end

  it "does not return elements for which the block returns nil" do
    list = List[1, 2, 3, 2, 1]
    result = list.chunk { |x| x == 2 ? nil : 1 }.to_a
    result.should == [List[1, List[1]], List[1, List[3]], List[1, List[1]]]
  end

  describe "with [initial_state]" do
    it "yields an element and an object value-equal but not identical to the object passed to #chunk" do
      list = List[1]
      value = "value"

      list.chunk(value) do |x, v|
        x.should == 1
        v.should == value
        v.should_not equal(value)
      end.to_a
    end

    it "does not yield the object passed to #chunk if it is nil" do
      acc = []
      list = List[1]
      list.chunk(nil) { |*x| acc << x }.to_a
      acc.should == [[1]]
    end
  end
end