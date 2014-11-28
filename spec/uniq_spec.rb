require 'spec_helper'

describe "#uniq" do
  it "returns an list with no duplicates" do
    List["a", "a", "b", "b", "c"].uniq.should == List["a", "b", "c"]
  end

  it "properly handles recursive lists" do
    empty = ListSpecs.empty_recursive_list
    empty.uniq.should == List[empty]

    list = ListSpecs.recursive_list
    list.uniq.should == List[1, 'two', 3.0, list]
  end

  it "uses eql? semantics" do
    List[1.0, 1].uniq.should == List[1.0, 1]
  end

  # TODO I don't understand this
  # it "compares elements based on the value returned from the block" do
  #   list = List[1, 2, 3, 4]
  #   list.uniq { |x| x >= 2 ? 1 : 0 }.should == List[1, 2]
  # end

  it "yields items in order" do
    list = List[1, 2, 3]
    yielded = List[]
    list.uniq { |v| yielded << v }
    yielded.should == list
  end

  it "handles nil and false like any other values" do
    [nil, false, 42].uniq { :foo }.should == [nil]
    [false, nil, 42].uniq { :bar }.should == [false]
  end

  it "returns subclass instance on List subclasses" do
    ListSubclass[1, 2, 3].uniq.should be_an_instance_of(ListSubclass)
  end
end