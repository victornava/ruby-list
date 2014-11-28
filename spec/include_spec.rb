require 'spec_helper'

describe "#include?" do
  it "returns true if any element == argument for numbers" do
    class IncludeP; def ==(obj) obj == 5; end; end

    list = List[0,1,2,3,4,5]
    list.include?(5).should == true
    list.include?(10).should == false
    list.include?(IncludeP.new).should == true
  end

  it "returns true if any element == argument for other objects" do
    class IncludeP11; def ==(obj); obj == '11'; end; end
    list = List['0','1','2','3','4', '5', IncludeP11.new]
    list.include?('5').should == true
    list.include?('10').should == false
    list.include?(IncludeP11.new).should == true
    list.include?('11').should == true
  end

  it "calls == on elements from left to right until success" do
    key = "x"
    one = double('one')
    two = double('two')
    three = double('three')
    one.should_receive(:==).and_return(false)
    two.should_receive(:==).and_return(true)
    three.should_not_receive(:==)
    List[one, two, three].include?(key).should == true
  end
end