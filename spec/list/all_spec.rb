require 'spec_helper'

describe "#all?" do
  before :each do
    @empty = List[]
    @list1 = List[0, 1, 2, -1]
    @list2 = List[nil, false, true]
  end

  it "always returns true on empty enumeration" do
    @empty.all?.should == true
    @empty.all? { nil }.should == true
  end

  it "does not hide exceptions out of #each" do
    lambda {
      ListThrowingErrorOnEach.new.all?
    }.should raise_error(RuntimeError)

    lambda {
      ListThrowingErrorOnEach.new.all? { false }
    }.should raise_error(RuntimeError)
  end

  describe "with no block" do
    it "returns true if no elements are false or nil" do
      @list1.all?.should == true
      @list2.all?.should == false
      List['a','b','c'].all?.should == true
      List[0, "x", true].all?.should == true
    end

    it "returns false if there are false or nil elements" do
      List[false].all?.should == false
      List[false, false].all?.should == false

      List[nil].all?.should == false
      List[nil, nil].all?.should == false

      List[1, nil, 2].all?.should == false
      List[0, "x", false, true].all?.should == false
    end
  end

  describe "with block" do
    it "returns true if the block never returns false or nil" do
      @list1.all? { true }.should == true
      @list1.all?{ |o| o < 5 }.should == true
      @list1.all?{ |o| 5 }.should == true
    end

    it "returns false if the block ever returns false or nil" do
      @list1.all? { false }.should == false
      @list1.all? { nil }.should == false
      @list1.all?{ |o| o > 2 }.should == false

      ListSpecs.numerous.all? { |i| i > 5 }.should == false
      ListSpecs.numerous.all? { |i| i == 3 ? nil : true }.should == false
    end

    it "does not hide exceptions out of the block" do
      lambda {
        @list1.all? { raise "from block" }
      }.should raise_error(RuntimeError)
    end
  end
end


