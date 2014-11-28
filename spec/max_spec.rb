require 'spec_helper'

describe "#max" do
  before :each do
    @l = List[2, 4, 6, 8, 10]
    @l_strs = List["333", "22", "666666", "1", "55555", "1010101010"]
    @l_ints = List[ 333,   22,   666666,   55555, 1010101010]
  end

  it "max should return the maximum element" do
    ListSpecs.numerous.max.should == 6
  end

  it "returns the maximum element (basics cases)" do
    List[55].max.should == 55

    List[11,99].max.should == 99
    List[99,11].max.should == 99
    List[2, 33, 4, 11].max.should == 33

    List[1,2,3,4,5].max.should == 5
    List[5,4,3,2,1].max.should == 5
    List[1,4,3,5,2].max.should == 5
    List[5,5,5,5,5].max.should == 5

    List["aa","tt"].max.should == "tt"
    List["tt","aa"].max.should == "tt"
    List["2","33","4","11"].max.should == "4"

    @l_strs.max.should == "666666"
    @l_ints.max.should == 1010101010
  end

  it "returns nil for an empty Enumerable" do
    List[].max.should == nil
  end

  it "raises a NoMethodError for elements without #<=>" do
    lambda do
      List[Object.new, Object.new].max
    end.should raise_error(NoMethodError)
  end

  it "raises an ArgumentError for incomparable elements" do
    lambda do
      List[11,"22"].max
    end.should raise_error(ArgumentError)
    lambda do
      List[11,12,22,33].max{|a, b| nil}
    end.should raise_error(ArgumentError)
  end

  it "returns the maximum element (with block)" do
    List["2","33","4","11"].max {|a,b| a <=> b }.should == "4"
    List[ 2 , 33 , 4 , 11 ].max {|a,b| a <=> b }.should == 33

    List["2","33","4","11"].max {|a,b| b <=> a }.should == "11"
    List[ 2 , 33 , 4 , 11 ].max {|a,b| b <=> a }.should == 2

    @l_strs.max {|a,b| a.size <=> b.size }.should == "1010101010"

    @l_strs.max {|a,b| a <=> b }.should == "666666"
    @l_strs.max {|a,b| a.to_i <=> b.to_i }.should == "1010101010"

    @l_ints.max {|a,b| a <=> b }.should == 1010101010
    @l_ints.max {|a,b| a.to_s <=> b.to_s }.should == 666666
  end

  it "returns the minimum for enumerables that contain nils" do
    list = List[nil, nil, true]
    list.max { |a, b|
      x = a.nil? ? 1 : a ? 0 : -1
      y = b.nil? ? 1 : b ? 0 : -1
      x <=> y
    }.should == nil
  end
end


