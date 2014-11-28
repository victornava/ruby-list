require 'spec_helper'

describe "#min" do
  before :each do
    @l = List[2, 4, 6, 8, 10]
    @l_strs = List["333", "22", "666666", "1", "55555", "1010101010"]
    @l_ints = List[ 333,   22,   666666,   55555, 1010101010]
  end

  it "min should return the minimum element" do
    ListSpecs.numerous.min.should == 1
  end

  it "returns the minimum (basic cases)" do
    List[55].min.should == 55

    List[11,99].min.should ==  11
    List[99,11].min.should == 11
    List[2, 33, 4, 11].min.should == 2

    List[1,2,3,4,5].min.should == 1
    List[5,4,3,2,1].min.should == 1
    List[4,1,3,5,2].min.should == 1
    List[5,5,5,5,5].min.should == 5

    List["aa","tt"].min.should == "aa"
    List["tt","aa"].min.should == "aa"
    List["2","33","4","11"].min.should == "11"

    @l_strs.min.should == "1"
    @l_ints.min.should == 22
  end

  it "returns nil for an empty list" do
    List[].min.should be_nil
  end

  it "raises a NoMethodError for elements without #<=>" do
    lambda do
      List[Object.new, Object.new].max
    end.should raise_error(NoMethodError)
  end

  it "raises an ArgumentError for incomparable elements" do
    lambda do
      List[11,"22"].min
    end.should raise_error(ArgumentError)

    lambda do
      List[11,12,22,33].min{|a, b| nil}
    end.should raise_error(ArgumentError)
  end

  it "returns the minimum when using a block rule" do
    List["2","33","4","11"].min {|a,b| a <=> b }.should == "11"
    List[ 2 , 33 , 4 , 11 ].min {|a,b| a <=> b }.should == 2
    List["2","33","4","11"].min {|a,b| b <=> a }.should == "4"
    List[2 , 33 , 4 , 11 ].min {|a,b| b <=> a }.should == 33
    List[1, 2, 3, 4].min {|a,b| 15 }.should == 1
    List[11,12,22,33].min{|a, b| 2 }.should == 11

    @i = -2
    List[11,12,22,33].min{|a, b| @i += 1 }.should == 12

    @l_strs.min {|a,b| a.size <=> b.size }.should == "1"
    @l_strs.min {|a,b| a <=> b }.should == "1"
    @l_strs.min {|a,b| a.to_i <=> b.to_i }.should == "1"
    @l_ints.min {|a,b| a <=> b }.should == 22
    @l_ints.min {|a,b| a.to_s <=> b.to_s }.should == 1010101010
  end

  it "returns the minimum for lists that contain nils" do
    list = List[nil, nil, true]
    list.min { |a, b|
      x = a.nil? ? -1 : a ? 0 : 1
      y = b.nil? ? -1 : b ? 0 : 1
      x <=> y
    }.should == nil
  end
end


