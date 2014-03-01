require 'spec_helper'
require 'list'

describe "::[]" do
  it "returns a new list populated with the given elements" do
    obj = Object.new
    List[5, true, nil, 'a', "Ruby", obj]._array.should == [5, true, nil, "a", "Ruby", obj]
  end
end

describe "#[]" do
  it "delegates to Array" do
    List[0,1,2][1].should == 1
  end
end

describe "#each" do
  it "delegates to Array" do
    List[1,2].each.inspect.should  == [1,2].each.inspect
  end
end

describe "#==" do
  it "delegates to Array" do
    List[1,2].should == List[1,2]
  end
end

describe "#map" do
  it "returns a copy of list with each element replaced by the value returned by block" do
    a = List['a', 'b', 'c', 'd']
    b = a.map { |i| i + '!' }
    b.should == List["a!", "b!", "c!", "d!"]
    b.object_id.should_not == a.object_id
  end

  it "does not return subclass instance" do
    List[1, 2, 3].map { |x| x + 1 }.should be_an_instance_of(List)
  end

  it "does not change self" do
    a = List['a', 'b', 'c', 'd']
    b = a.map { |i| i + '!' }
    a.should == List['a', 'b', 'c', 'd']
  end

  it "returns the evaluated value of block if it broke in the block" do
    a = List['a', 'b', 'c', 'd']
    b = a.map {|i|
      if i == 'c'
        break 0
      else
        i + '!'
      end
    }
    b.should == 0
  end

  it "returns an Enumerator when no block given" do
    a = [1, 2, 3]
    a.map.should be_an_instance_of(Enumerator)
  end

  it "does not copy tainted status" do
    a = Array[1, 2, 3]
    a.taint
    a.map {|x| x}.tainted?.should be_false
  end

  it "does not copy untrusted status" do
    a = List[1, 2, 3]
    a.untrust
    a.map {|x| x}.untrusted?.should be_false
  end
end

