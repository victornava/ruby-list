require 'spec_helper'

describe "#rindex" do
  it "returns size-1 if last element == to object" do
    List[2, 1, 3, 2, 5].rindex(5).should == 4
  end

  it "returns 0 if only first element == to object" do
    List[2, 1, 3, 1, 5].rindex(2).should == 0
  end

  it "returns nil if no element == to object" do
    List[1, 1, 3, 2, 1, 3].rindex(4).should == nil
  end

  it "returns correct index even after delete_at" do
    list = ["fish", "bird", "lion", "cat"]
    list.delete_at(0)
    list.rindex("lion").should == 1
  end

  it "properly handles empty recursive lists" do
    empty = ListSpecs.empty_recursive_list
    empty.rindex(empty).should == 0
    empty.rindex(1).should be_nil
  end

  it "properly handles recursive lists" do
    list = ListSpecs.recursive_list
    list.rindex(1).should == 0
    list.rindex(list).should == 7
  end

  it "accepts a block instead of an argument" do
    List[4, 2, 1, 5, 1, 3].rindex { |x| x < 2 }.should == 4
  end

  it "ignores the block if there is an argument" do
    List[4, 2, 1, 5, 1, 3].rindex(5) { |x| x < 2 }.should == 3
  end

  describe "given no argument and no block" do
    it "produces an Enumerator" do
      enum = List[4, 2, 1, 5, 1, 3].rindex
      enum.should be_an_instance_of(Enumerator)
      List[*enum].should == List[4, 2, 1, 5, 1, 3]
    end
  end
end
