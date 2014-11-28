require 'spec_helper'

describe "#each_with_index" do

  before :each do
    @b = List[2, 5, 3, 6]
    @c = List[List[2, 0], List[5, 1], List[3, 2], List[6, 3]]
  end

  it "passes each element and its index to block" do
    @a = List[]
    @b.each_with_index { |o, i| @a << List[o, i] }
    @a.should == @c
  end

  it "provides each element to the block" do
    acc = List[]
    obj = List[]
    res = obj.each_with_index { |a,i| acc << List[a,i] }
    acc.should == List[]
    obj.should == res
  end

  it "provides each element to the block and its index" do
    acc = List[]
    res = @b.each_with_index {|a,i| acc << List[a,i]}
    @c.should == acc
    res.should eql(@b)
  end

  it "binds splat arguments properly" do
    acc = List[]
    res = @b.each_with_index { |*b| c,d = b; acc << c; acc << d }
    List[2, 0, 5, 1, 3, 2, 6, 3].should == acc
    res.should eql(@b)
  end
end
