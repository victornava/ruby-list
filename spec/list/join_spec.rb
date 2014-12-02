require 'spec_helper'

describe "#join" do
  describe "with default separator" do
    before(:each) do
      @separator = $,
    end

    after(:each) do
      $, = @separator
    end

    it "returns an empty string if the List is empty" do
      List[].join.should == ''
    end

    it "returns a string formed by concatenating each String element separated by $," do
      $, = " | "
      List["1", "2", "3"].join.should == "1 | 2 | 3"
    end
  end

  describe "with string separator" do
    it "returns a string formed by concatenating each element.to_s separated by separator" do
      obj = double('foo')
      obj.should_receive(:to_s).and_return("foo")
      List[1, 2, 3, 4, obj].join(' | ').should == '1 | 2 | 3 | 4 | foo'
    end

    it "uses the same separator with nested lists" do
      List[1, List[2, List[3, 4], 5], 6].join(":").should == "1:2:3:4:5:6"
    end

    describe "with a tainted separator" do
      before :each do
        @sep = ":".taint
      end

      it "does not taint the result if the list is empty" do
        List[].join(@sep).tainted?.should be_false
      end

      it "taints the result if the list has two or more elements" do
        List[1, 2].join(@sep).tainted?.should be_true
      end
    end

    describe "with an untrusted separator" do
      before :each do
        @sep = ":".untrust
      end

      it "does not untrust the result if the list is empty" do
        List[].join(@sep).untrusted?.should be_false
      end

      it "untrusts the result if the list has two or more elements" do
        List[1, 2].join(@sep).untrusted?.should be_true
      end
    end
  end
end