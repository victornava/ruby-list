require 'spec_helper'

describe "#select" do
  it "returns an Enumerator if no block given" do
    [1,2].select.should be_an_instance_of(Enumerator)
  end

  it "returns a new List of elements for which block is true" do
    List[1, 3, 4, 5, 6, 9].select { |i| i % 2 == 0}.should == List[4, 6]
  end

  it "does not return subclass instance on List subclasses" do
    ListSubclass[1, 2, 3].select { true }.should be_an_instance_of(List)
  end

  it "properly handles recursive lists" do
    empty = ListSpecs.empty_recursive_list
    empty.select { true }.should == empty
    empty.select { false }.should == List[]

    list = ListSpecs.recursive_list
    list.select { true }.should == list
    list.select { false }.should == List[]
  end
end

