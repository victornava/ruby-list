require 'spec_helper'

describe "#each_with_object" do
  before :each do
    @values = List[2, 5, 3, 6, 1, 4]
    @list = @values.dup
    @initial = "memo"
  end

  it "passes each element and its argument to the block" do
    acc = List[]
    @list.each_with_object(@initial) do |elem, obj|
      obj.should equal(@initial)
      obj = 42
      acc << elem
    end.should equal(@initial)
    acc.should == @values
  end

  it "returns an enumerator if no block" do
    acc = List[]
    e = @list.each_with_object(@initial)
    e.each do |elem, obj|
      obj.should equal(@initial)
      obj = 42
      acc << elem
    end.should equal(@initial)
    acc.should == @values
  end
end
