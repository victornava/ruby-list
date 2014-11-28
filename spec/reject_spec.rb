require 'spec_helper'

describe "#reject" do
  it "returns a new list without elements for which block is true" do
    list = List[1, 2, 3, 4, 5]
    list.reject { true }.should == List[]
    list.reject { false }.should == list
    list.reject { false }.object_id.should_not == list.object_id
    list.reject { nil }.should == list
    list.reject { nil }.object_id.should_not == list.object_id
    list.reject { 5 }.should == List[]
    list.reject { |i| i < 3 }.should == List[3, 4, 5]
    list.reject { |i| i % 2 == 0 }.should == List[1, 3, 5]
  end

  it "properly handles recursive lists" do
    empty = ListSpecs.empty_recursive_list
    empty.reject { false }.should == List[empty]
    empty.reject { true }.should == List[]

    list = ListSpecs.recursive_list
    list.reject { false }.should == list
    list.reject { true }.should == List[]
  end

  it "does not return subclass instance on List subclasses" do
    ListSubclass[1, 2, 3].reject { |x| x % 2 == 0 }.should be_an_instance_of(List)
  end

  it "does not retain instance variables" do
    list = List[]
    list.instance_variable_set("@variable", "value")
    list.reject { false }.instance_variable_get("@variable").should == nil
  end

  it "returns an Enumerator if no block given" do
    [1,2].reject.should be_an_instance_of(Enumerator)
  end
end

