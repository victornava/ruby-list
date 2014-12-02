require 'spec_helper'

describe "#each_slice" do
  before :each do
    @list = List[7,6,5,4,3,2,1]
    @sliced = List[List[7,6,5], List[4,3,2], List[1]]
  end

  it "passes element groups to the block" do
    acc = List[]
    @list.each_slice(3){|g| acc << g}.should be_nil
    acc.should == @sliced
  end

  it "raises an Argument Error if there is not a single parameter > 0" do
    lambda{ @list.each_slice(0){}    }.should raise_error(ArgumentError)
    lambda{ @list.each_slice(-2){}   }.should raise_error(ArgumentError)
    lambda{ @list.each_slice{}       }.should raise_error(ArgumentError)
    lambda{ @list.each_slice(2,2){}  }.should raise_error(ArgumentError)
  end

  it "tries to convert n to an Integer using #to_int" do
    acc = List[]
    @list.each_slice(3.3){|g| acc << g}.should == nil
    acc.should == @sliced

    obj = double('to_int')
    obj.should_receive(:to_int).and_return(3)
    @list.each_slice(obj){|g| break g.size}.should == 3
  end

  it "works when n is >= full size" do
    full = @list
    acc = List[]
    @list.each_slice(full.size){|g| acc << g}
    acc.should == List[full]
    acc = List[]
    @list.each_slice(full.size+1){|g| acc << g}
    acc.should == List[full]
  end

  it "yields only as much as needed" do
    times_yielded = 0
    cnt = [1, 2, :stop, "I said stop!", :got_it]
    cnt.each_slice(2) {|g| times_yielded += 1; break 42 if g[0] == :stop }.should == 42
    times_yielded.should == 2
  end

  it "returns an enumerator if no block" do
    @list.each_slice(3).should be_an_instance_of(Enumerator)
  end
end