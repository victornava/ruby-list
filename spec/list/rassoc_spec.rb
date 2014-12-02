require 'spec_helper'

describe "#rassoc" do
  it "returns the first contained array whose second element is == object" do
    list = List[List[1, "a", 0.5], List[2, "b"], List[3, "b"], List[4, "c"], List[], List[5], List[6, "d"]]
    list.rassoc("a").should == List[1, "a", 0.5]
    list.rassoc("b").should == List[2, "b"]
    list.rassoc("d").should == List[6, "d"]
    list.rassoc("z").should == nil
  end

  it "properly handles recursive lists" do
    empty = ListSpecs.empty_recursive_list
    empty.rassoc(List[]).should be_nil
    List[List[empty, empty]].rassoc(empty).should == List[empty, empty]

    list = ListSpecs.recursive_list
    list.rassoc(list).should be_nil
    List[List[empty, list]].rassoc(list).should == List[empty, list]
  end

  it "calls elem == obj on the second element of each contained list" do
    key = 'foobar'
    o = double('foobar')
    def o.==(other); other == 'foobar'; end

    List[List[1, :foobar], List[2, o], List[3, double('foo')]].rassoc(key).should == List[2, o]
  end

  it "does not check the last element in each contained but speficically the second" do
    key = 'foobar'
    o = double('foobar')
    def o.==(other); other == 'foobar'; end

    List[List[1, :foobar, o], List[2, o, 1], List[3, double('foo')]].rassoc(key).should == List[2, o, 1]
  end
end
