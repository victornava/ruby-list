require 'spec_helper'

describe "#each_cons" do
  before :each do
    @list = List[4,3,2,1]
    @in_threes = [[4,3,2], [3,2,1]]
  end

  it "passes element groups to the block and returns nil" do
    acc = []
    @list.each_cons(3) {|g| acc << g}.should be_nil
    acc.should == @in_threes
  end

  it "raises an Argument Error if there is not a single parameter > 0" do
    lambda{ @list.each_cons(0){}    }.should raise_error(ArgumentError)
    lambda{ @list.each_cons(-2){}   }.should raise_error(ArgumentError)
    lambda{ @list.each_cons{}       }.should raise_error(ArgumentError)
    lambda{ @list.each_cons(2,2){}  }.should raise_error(ArgumentError)
  end

  it "tries to convert n to an Integer using #to_int" do
    acc = []
    @list.each_cons(3.3){|g| acc << g}.should == nil
    acc.should == @in_threes

    obj = double('to_int')
    obj.should_receive(:to_int).and_return(3)
    @list.each_cons(obj){|g| break g.size}.should == 3
  end

  it "works when n is >= full size" do
    acc = []
    full = @list.to_a
    @list.each_cons(full.size){|g| acc << g}
    acc.should == [full]
    acc = []
    @list.each_cons(full.size+1){|g| acc << g}
    acc.should == []
  end

  it "yields only as much as needed" do
    counter = 0
    cnt = [1, 2, :stop, "I said stop!", :got_it]
    cnt.each_cons(2) {|g| counter += 1; break 42 if g.last == :stop }.should == 42
    counter.should == 2
  end

  it "returns an enumerator if no block" do
    e = @list.each_cons(3)
    e.should be_an_instance_of(Enumerator)
    e.to_a.should == @in_threes
  end
end
