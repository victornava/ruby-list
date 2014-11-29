require 'spec_helper'

describe "#rotate" do
  describe "when passed no argument" do
    it "returns a copy of the list with the first element moved at the end" do
      List[1, 2, 3, 4, 5].rotate.should == List[2, 3, 4, 5, 1]
    end
  end

  describe "with an argument n" do
    it "returns a copy of the list with the first (n % size) elements moved at the end" do
      l = List[1, 2, 3, 4, 5]
      l.rotate(  2).should == List[3, 4, 5, 1, 2]
      l.rotate( -1).should == List[5, 1, 2, 3, 4]
      l.rotate(-21).should == List[5, 1, 2, 3, 4]
      l.rotate( 13).should == List[4, 5, 1, 2, 3]
      l.rotate(  0).should == l
    end

    it "coerces the argument using to_int" do
      List[1, 2, 3].rotate(2.6).should == List[3, 1, 2]

      obj = double('integer_like')
      obj.should_receive(:to_int).and_return(2)
      List[1, 2, 3].rotate(obj).should == List[3, 1, 2]
    end

    it "raises a TypeError if not passed an integer-like argument" do
      lambda {
        List[1, 2].rotate(nil)
      }.should raise_error(TypeError)
      lambda {
        List[1, 2].rotate("4")
      }.should raise_error(TypeError)
    end

    it "returns a copy of the array when its length is one or zero" do
      List[1].rotate.should == List[1]
      List[1].rotate(2).should == List[1]
      List[1].rotate(-42).should == List[1]
      List[ ].rotate.should == List[]
      List[ ].rotate(2).should == List[]
      List[ ].rotate(-42).should == List[]
    end

    it "does not mutate the receiver" do
      lambda {
        List[].freeze.rotate
        List[2].freeze.rotate(2)
        List[1,2,3].freeze.rotate(-3)
      }.should_not raise_error
    end

    it "does not return self" do
      l = List[1, 2, 3]
      l.rotate.should_not equal(l)
      l = List[]
      l.rotate(0).should_not equal(l)
    end

    it "does not return subclass instance for List subclasses" do
      ListSubclass[1, 2, 3].rotate.should be_an_instance_of(List)
    end
  end
end