require 'spec_helper'

describe "#eql?" do
  it "returns true if other is the same array" do
    l = List[1]
    l.eql?(l).should be_true
  end

  it "returns true if corresponding elements are #eql?" do
    List[].eql?(List[]).should be_true
    List[1, 2, 3, 4].eql?(List[1, 2, 3, 4]).should be_true
  end

  it "returns false if other is shorter than self" do
    List[1, 2, 3, 4].eql?(List[1, 2, 3]).should be_false
  end

  it "returns false if other is longer than self" do
    List[1, 2, 3, 4].eql?(List[1, 2, 3, 4, 5]).should be_false
  end

  it "returns false immediately when sizes of the lists differ" do
    obj = double('1')
    obj.should_not_receive(:eql?)

    List[].eql?(List[obj]).should be_false
    List[obj].eql?(List[]).should be_false
  end

  it "does not call #to_ary on its argument" do
    obj = double('to_ary')
    obj.should_not_receive(:to_ary)

    List[1, 2, 3].eql?(obj).should be_false
  end

  it "does not call #to_ary on List subclasses" do
    list = ListSubclass[5, 6, 7]
    list.should_not_receive(:to_ary)
    List[5, 6, 7].eql?(list).should be_true
  end

  it "ignores list class differences" do
    ListSubclass[1, 2, 3].eql?(List[1, 2, 3]).should be_true
    ListSubclass[1, 2, 3].eql?(ListSubclass[1, 2, 3]).should be_true
    List[1, 2, 3].eql?(ListSubclass[1, 2, 3]).should be_true
  end

  it "returns false if any corresponding elements are not #eql?" do
    List[1, 2, 3, 4].eql?(List[1, 2, 3, 4.0]).should be_false
  end
end