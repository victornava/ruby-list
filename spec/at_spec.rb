require 'spec_helper'

describe "#at" do
  it "returns the (n+1)'th element for the passed index n" do
    l = List[1, 2, 3, 4, 5, 6]
    l.at(0).should == 1
    l.at(1).should == 2
    l.at(5).should == 6
  end

  it "returns nil if the given index is greater than or equal to the list's length" do
    l = List[1, 2, 3, 4, 5, 6]
    l.at(6).should == nil
    l.at(7).should == nil
  end

  it "returns the (-n)'th elemet from the last, for the given negative index n" do
    l = List[1, 2, 3, 4, 5, 6]
    l.at(-1).should == 6
    l.at(-2).should == 5
    l.at(-6).should == 1
  end

  it "returns nil if the given index is less than -len, where len is length of the list"  do
    l = List[1, 2, 3, 4, 5, 6]
    l.at(-7).should == nil
    l.at(-8).should == nil
  end

  it "does not extend the list when the given index is out of range" do
    l = List[1, 2, 3, 4, 5, 6]
    l.size.should == 6
    l.at(100)
    l.size.should == 6
    l.at(-100)
    l.size.should == 6
  end

  it "tries to convert the passed argument to an Integer using #to_int" do
    l = List["a", "b", "c"]
    l.at(0.5).should == "a"

    obj = double('to_int')
    obj.should_receive(:to_int).and_return(2)
    l.at(obj).should == "c"
  end

  it "raises a TypeError when the passed argument can't be coerced to Integer" do
    lambda { List[].at("cat") }.should raise_error(TypeError)
  end

  it "raises an ArgumentError when 2 or more arguments is passed" do
    lambda { List[:a, :b].at(0,1) }.should raise_error(ArgumentError)
  end
end