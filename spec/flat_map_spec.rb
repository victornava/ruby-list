require 'spec_helper'

describe "flat_map" do
  it "returns a new list with the results of passing each element to block, flattened one level" do
    list = List[1, List[2, 3], List[4, List[5, 6]], {:foo => :bar}]
    list.flat_map { |i| i }.should == List[1, 2, 3, 4, List[5, 6], {:foo => :bar}]
  end

  it "skips elements that are empty Lists" do
    list = List[1, List[], 2]
    list.flat_map { |i| i }.should == List[1, 2]
  end

  it "returns an enumerator when no block given" do
    enum = List[1, 2].flat_map
    enum.should be_an_instance_of(Enumerator)
    List[*enum] == List[1, 2]
  end
end
