require 'spec_helper'

describe "#partition" do
  it "returns two lists" do
    List[].partition {}.should == List[List[], List[]]
  end

  it "returns in the left list values for which the block evaluates to true" do
    list = List[0, 1, 2, 3, 4, 5]

    list.partition { |i| true }.should == List[list, List[]]
    list.partition { |i| 5 }.should == List[list, List[]]
    list.partition { |i| false }.should == List[List[], list]
    list.partition { |i| nil }.should == List[List[], list]
    list.partition { |i| i % 2 == 0 }.should == List[List[0, 2, 4], List[1, 3, 5]]
    list.partition { |i| i / 3 == 0 }.should == List[List[0, 1, 2], List[3, 4, 5]]
  end

  it "properly handles recursive arrays" do
    empty = ListSpecs.empty_recursive_list
    empty.partition { true }.should == List[List[empty], List[]]
    empty.partition { false }.should == List[List[], List[empty]]

    list = ListSpecs.recursive_list
    list.partition { true }.should == List[
      List[1, 'two', 3.0, list, list, list, list, list],
      List[]
    ]
    condition = true
    list.partition { condition = !condition }.should == List[
      List['two', list, list, list],
      List[1, 3.0, list, list]
    ]
  end

  it "does not return subclass instances on Array subclasses" do
    result = ListSubclass[1, 2, 3].partition { |x| x % 2 == 0 }
    result.should be_an_instance_of(List)
    result[0].should be_an_instance_of(List)
    result[1].should be_an_instance_of(List)
  end
end
