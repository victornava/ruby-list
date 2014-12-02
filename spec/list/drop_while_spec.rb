require 'spec_helper'

describe "#drop_while" do
  before :each do
    @list = List[3, 2, 1, :go]
  end

  it "returns an Enumerator if no block given" do
    @list.drop_while.should be_an_instance_of(Enumerator)
  end

  it "returns no/all elements for {true/false} block" do
    @list.drop_while{true}.should == List[]
    @list.drop_while{false}.should == @list
  end

  it "accepts returns other than true/false" do
    @list.drop_while{1}.should == List[]
    @list.drop_while{nil}.should == @list
  end

  it "passes elements to the block until the first false" do
    a = []
    @list.drop_while{|obj| (a << obj).size < 3}.should == List[1, :go]
    a.should == [3, 2, 1]
  end

  it "will only go through what's needed" do
    list = List[1,2,3,4]
    list.drop_while { |x|
      break 42 if x == 3
      true
    }.should == 42
  end

  it "doesn't return self when it could" do
    l = List[1,2,3]
    l.drop_while{false}.should_not equal(l)
  end

  it "removes elements from the start of the array while the block evaluates to true" do
    List[1, 2, 3, 4].drop_while { |n| n < 4 }.should == List[4]
  end

  it "removes elements from the start of the array until the block returns nil" do
    List[1, 2, 3, nil, 5].drop_while { |n| n }.should == List[nil, 5]
  end

  it "removes elements from the start of the array until the block returns false" do
    List[1, 2, 3, false, 5].drop_while { |n| n }.should == List[false, 5]
  end
end
