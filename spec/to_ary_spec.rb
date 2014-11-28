require 'spec_helper'

describe "Array#to_ary" do
  it "returns self" do
    l = List[1, 2, 3]
    l.should equal(l.to_ary)
  end

  it "properly handles recursive arrays" do
    empty = ListSpecs.empty_recursive_list
    empty.to_ary.should == empty

    list = ListSpecs.recursive_list
    list.to_ary.should == list
  end

end
