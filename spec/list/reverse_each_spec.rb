require 'spec_helper'

describe "#reverse_each" do
  it "traverses list in reverse order and pass each element to block" do
    a = []
    List[2, 5, 3, 6, 1, 4].reverse_each { |i| a << i }
    a.should == [4, 1, 6, 3, 5, 2]
  end

  it "returns an Enumerator if no block given" do
    enum = List[2, 5, 3, 6, 1, 4].reverse_each
    enum.should be_an_instance_of(Enumerator)
    enum.to_a.should == [4, 1, 6, 3, 5, 2]
  end

  it "returns self" do
    l = List[:a, :b, :c]
    l.reverse_each { |x| }.should equal(l)
  end

  it "yields only the top level element of an empty recursive list" do
    a = []
    empty = ListSpecs.empty_recursive_list
    empty.reverse_each { |i| a << i }
    a.should == [empty]
  end

  it "yields only the top level element of a recursive list" do
    a = []
    list = ListSpecs.recursive_list
    list.reverse_each { |i| a << i }
    a.should == [list, list, list, list, list, 3.0, 'two', 1]
  end
end