require 'spec_helper'

describe "#reverse" do
  it "returns a new list with the elements in reverse order" do
    List[].reverse.should == List[]
    List[1, 3, 5, 2].reverse.should == List[2, 5, 3, 1]
  end

  it "properly handles recursive lists" do
    empty = ListSpecs.empty_recursive_list
    empty.reverse.should == empty

    list = ListSpecs.recursive_list
    list.reverse.should == List[list, list, list, list, list, 3.0, 'two', 1]
  end

  it "does not return subclass instance on List subclasses" do
    List[1, 2, 3].reverse.should be_an_instance_of(List)
  end
end