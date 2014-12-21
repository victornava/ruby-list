require 'spec_helper'

describe "#transpose" do
  it "assumes an list of lists and returns the result of transposing rows and columns" do
    List[List[1, 'a'], List[2, 'b'], List[3, 'c']].transpose.should == List[List[1, 2, 3], List["a", "b", "c"]]
    List[List[1, 2, 3], List["a", "b", "c"]].transpose.should == List[List[1, 'a'], List[2, 'b'], List[3, 'c']]
    List[].transpose.should == List[]
    List[List[]].transpose.should == List[]
    List[List[], List[]].transpose.should == List[]
    List[List[0]].transpose.should == List[List[0]]
    List[List[0], List[1]].transpose.should == List[List[0, 1]]
  end

  it "tries to convert the passed argument to an List using #to_ary" do
    obj = double('[1,2]')
    obj.should_receive(:to_ary).and_return([1, 2])
    List[obj, List[:a, :b]].transpose.should == List[List[1, :a], List[2, :b]]
  end

  it "properly handles recursive lists" do
    empty = ListSpecs.empty_recursive_list
    empty.transpose.should == empty

    a = List[]; a << a
    b = List[]; b << b
    List[a, b].transpose.should == List[List[a, b]]

    a = List[1]; a << a
    b = List[2]; b << b
    List[a, b].transpose.should == List[ List[1, 2], List[a, b] ]
  end

  it "raises a TypeError if the passed Argument does not respond to #to_ary" do
    lambda { List[Object.new, List[:a, :b]].transpose }.should raise_error(TypeError)
  end

  it "raises an IndexError if the lists are not of the same length" do
    lambda { List[List[1, 2], List[:a]].transpose }.should raise_error(IndexError)
  end

  it "does not return subclass instance on List subclasses" do
    result = ListSubclass[ListSubclass[1, 2, 3], ListSubclass[4, 5, 6]].transpose
    result.should be_an_instance_of(List)
    result[0].should be_an_instance_of(List)
    result[1].should be_an_instance_of(List)
  end
end
