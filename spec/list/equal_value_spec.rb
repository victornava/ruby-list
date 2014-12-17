require 'spec_helper'

describe "#==" do
  it "returns true if other is the same array" do
    l = List[1]
    (l == l).should be_true
  end

  it "returns true if corresponding elements are #eql?" do
    (List[] == List[]).should be_true
    (List[1, 2, 3, 4] == List[1, 2, 3, 4]).should be_true
  end

  it "returns false if other is shorter than self" do
    (List[1, 2, 3, 4] == List[1, 2, 3]).should be_false
  end

  it "returns false if other is longer than self" do
    (List[1, 2, 3, 4] == List[1, 2, 3, 4, 5]).should be_false
  end

  it "returns false immediately when sizes of the arrays differ" do
    obj = double('1')
    obj.should_not_receive(:==)

    (List[] == List[obj]).should be_false
    (List[obj] == List[]).should be_false
  end

  it "does not call #to_ary on List subclasses" do
    list = ListSubclass[5, 6, 7]
    list.should_not_receive(:to_ary)
    (List[5, 6, 7] == list).should be_true
  end

  it "compares with an equivalent List-like object using #to_ary" do

    obj = Object.new
    def obj.to_ary; [1]; end
    def obj.==(arg); to_ary == arg; end

    (List[1] == obj).should be_true
    (List[List[1]] == List[obj]).should be_true
    (List[List[List[1], 3], 2] == List[List[obj, 3], 2]).should be_true

    # recursive lists
    list1 = List[List[1]]
    list1 << list1
    list2 = List[obj]
    list2 << list2

    (list1 == list2).should be_true
    (list2 == list1).should be_true


    list1 = List[List[1]]
    list1 << list1 << 3
    list2 = List[obj]
    list2 << 2 << 3

    (list1 == list2).should be_false
    (list2 == list1).should be_false
  end

  it "returns false if any corresponding elements are not #==" do
    a = List["a", "b", "c"]
    b = List["a", "b", "not equal value"]
    a.should_not == b

    c = double("c")
    c.should_receive(:==).and_return(false)
    List["a", "b", c].should_not == a
  end

  it "returns true if corresponding elements are #==" do
    List[].should == List[]
    List["a", "c", 7].should == List["a", "c", 7]

    List[1, 2, 3].should == List[1.0, 2.0, 3.0]

    obj = double('5')
    obj.should_receive(:==).and_return(true)
    List[obj].should == List[5]
  end
end
