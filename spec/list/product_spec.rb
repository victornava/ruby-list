require 'spec_helper'


describe "#product" do
  # it "returns converted arguments using :to_ary" do
  #   lambda{ List[1].product(2..3) }.should raise_error(TypeError)
  #   ar = ListSpecs::ListConvertable.new(2,3)
  #   List[1].product(ar).should == List[List[1,2],List[1,3]]
  #   ar.called.should == :to_ary
  # end

  it "returns the expected result with one list" do
    List[1, 2].product(List[3, 4]).should == List[
      List[1, 3], List[1, 4], List[2, 3], List[2, 4]
    ]
  end

  it "returns the expected result with more than one list" do
    List[1,2].product(List[3,4,5],List[6,8]).should == List[
      List[1, 3, 6], List[1, 3, 8], List[1, 4, 6], List[1, 4, 8], List[1, 5, 6], List[1, 5, 8],
      List[2, 3, 6], List[2, 3, 8], List[2, 4, 6], List[2, 4, 8], List[2, 5, 6], List[2, 5, 8]
    ]
  end

  it "has no required argument" do
    List[1,2].product.should == List[List[1],List[2]]
  end

  it "returns an empty list when the argument is an empty list" do
    List[1, 2].product(List[]).should == List[]
  end

  describe "when given a block" do
    it "yields all combinations in turn" do
      acc = List[]
      List[1,2].product(List[3,4,5],List[6,8]){|list| acc << list}
      acc.should == List[List[1, 3, 6], List[1, 3, 8], List[1, 4, 6], List[1, 4, 8], List[1, 5, 6], List[1, 5, 8],
                     List[2, 3, 6], List[2, 3, 8], List[2, 4, 6], List[2, 4, 8], List[2, 5, 6], List[2, 5, 8]]

      acc = List[]
      List[1,2].product(List[3,4,5],List[],List[6,8]){|list| acc << list}
      acc.should be_empty
    end
  end

  describe "when given an empty block" do
    it "returns self" do
      list = List[1,2]
      list.product(List[3,4,5],List[6,8]){}.should equal(list)
      list = List[]
      list.product(List[3,4,5],List[6,8]){}.should equal(list)
      list = List[1,2]
      list.product(List[]){}.should equal(list)
    end
  end
end