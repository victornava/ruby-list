require 'spec_helper'

describe "#values_at" do
  it "returns an list of elements at the indexes when passed indexes" do
    List[1, 2, 3, 4, 5].values_at().should == List[]
    List[1, 2, 3, 4, 5].values_at(1, 0, 5, -1, -8, 10).should == List[2, 1, nil, 5, nil, nil]
  end

  it "calls to_int on its indices" do
    obj = double('1')
    def obj.to_int() 1 end
    List[1, 2].values_at(obj, obj, obj).should == List[2, 2, 2]
  end

  # Don't really care about this
  # it "properly handles recursive lists" do
  #   empty = ListSpecs.empty_recursive_list
  #   empty.values_at(0, 1, 2).should == List[empty, nil, nil]
  #
  #   list = ListSpecs.recursive_list
  #   list.values_at(0, 1, 2, 3).should == List[1, 'two', 3.0, list]
  # end

  describe "when passed ranges" do
    it "returns an list of elements in the ranges" do
      List[1, 2, 3, 4, 5].values_at(0..2, 1...3, 2..-2).should == List[1, 2, 3, 2, 3, 3, 4]
      List[1, 2, 3, 4, 5].values_at(6..4).should == List[]
    end

    it "calls to_int on arguments of ranges" do
      from = double('from')
      to = double('to')

      # So we can construct a range out of them...
      def from.<=>(o) 0 end
      def to.<=>(o) 0 end

      def from.to_int() 1 end
      def to.to_int() -2 end

      list = List[1, 2, 3, 4, 5]
      list.values_at(from .. to, from ... to, to .. from).should == List[2, 3, 4, 2, 3]
    end
  end

  describe "when passed a range" do
    it "fills with nil if the index is out of the range" do
      List[0, 1].values_at(0..3).should == List[0, 1, nil, nil]
      List[0, 1].values_at(2..4).should == List[nil, nil, nil]
    end

    describe "on an empty list" do
      it "fills with nils if the index is out of the range" do
        List[].values_at(0..2).should == List[nil, nil, nil]
        List[].values_at(1..3).should == List[nil, nil, nil]
      end
    end
  end

  it "does not return subclass instance on List subclasses" do
    ListSubclass[1, 2, 3].values_at(0, 1..2, 1).should be_an_instance_of(List)
  end
end
