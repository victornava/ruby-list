require 'spec_helper'

describe "#reduce" do

  before do
    @list = List[2, 5, 3, 6, 1, 4]
  end

  it "with argument takes a block with an accumulator (with argument as initial value) and the current element. Value of block becomes new accumulator" do
    a = []
    @list.reduce(0) { |memo, i| a << [memo, i]; i }
    a.should == [[0, 2], [2, 5], [5, 3], [3, 6], [6, 1], [1, 4]]
    List[true, true, true].reduce(nil) {|result, i| i && result}.should == nil
  end

  it "produces an list of the accumulator and the argument when given a block with a *arg" do
    a = []
    List[1,2].reduce(0) {|*args| a << args; args[0] + args[1]}
    a.should == [[0, 1], [1, 2]]
  end

  it "without argument takes a block with an accumulator (with first element as initial value) and the current element. Value of block becomes new accumulator" do
    a = []
    @list.reduce { |memo, i| a << [memo, i]; i }
    a.should == [[2, 5], [5, 3], [3, 6], [6, 1], [1, 4]]
  end

  it "gathers whole lists as elements when each yields multiple" do
    List[List[1,2], List[3,4,5]].reduce(List[]) {|acc, e| acc << e }.should == List[List[1,2], List[3,4,5]]
  end

  it "with inject arguments" do
    List[].reduce(1) {|acc,x| 999 }.should == 1
    List[2].reduce(1) {|acc,x| 999 }.should ==  999
    List[2].reduce(1) {|acc,x| acc }.should == 1
    List[2].reduce(1) {|acc,x| x }.should == 2
    List[1,2,3,4].reduce(100) {|acc,x| acc + x }.should == 110
    List[1,2,3,4].reduce(100) {|acc,x| acc * x }.should == 2400
    List['a','b','c'].reduce("z") {|result, i| i+result}.should == "cbaz"
  end

  it "without inject arguments" do
    List[2].reduce {|acc,x| 999 } .should == 2
    List[2].reduce {|acc,x| acc }.should == 2
    List[2].reduce {|acc,x| x }.should == 2
    List[1,2,3,4].reduce {|acc,x| acc + x }.should == 10
    List[1,2,3,4].reduce {|acc,x| acc * x }.should == 24
    List['a', 'b', 'c'].reduce {|result, i| i+result}.should == "cba"
    List[3,4,5].reduce {|result, i| result*i}.should == 60
    List[List[1], 2, 'a','b'].reduce {|r,i| r<<i}.should == List[1, 2, 'a', 'b']
  end

  it "returns nil when fails" do
    List[].reduce {|acc,x| 999 }.should == nil
  end
end


