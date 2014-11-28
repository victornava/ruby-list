require 'spec_helper'

describe "#grep" do
  it "grep without a block should return a list of all elements === pattern" do
    class EnumerableSpecGrep; def ===(obj); obj == '2'; end; end

    List['2', 'a', 'nil', '3', false].grep(EnumerableSpecGrep.new).should == List['2']
  end

  it "grep with a block should return a list of elements === pattern passed through block" do
    class EnumerableSpecGrep2; def ===(obj); /^ca/ =~ obj; end; end
    list  = List["cat", "coat", "car", "cadr", "cost"]
    list.grep(EnumerableSpecGrep2.new) { |i| i.upcase }.should == List["CAT", "CAR", "CADR"]
  end

  it "grep the enumerable (rubycon legacy)" do
    List[].grep(1).should == List[]
    list = List[2, 4, 6, 8, 10]
    list.grep(3..7).should == List[4,6]
    list.grep(3..7) {|a| a+1}.should == List[5,7]
  end

  # TODO Can't figure out how to do this :(
  # it "can use $~ in the block when used with a Regexp" do
  #   List["aba", "aba"].grep(/a(b)a/) { $1 }.should == List["b", "b"]
  # end
end
