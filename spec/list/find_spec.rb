require 'spec_helper'

describe "#find" do
  before :each do
    @elements = [2, 4, 6, 8, 10]
    @list = List[*@elements]
    @empty = List[]
  end

  it "passes each entry in list to block while block when block is false" do
    visited_elements = []
    @list.find do |element|
      visited_elements << element
      false
    end
    visited_elements.should == @elements
  end

  it "returns nil when the block is false and there is no ifnone proc given" do
    @list.find {|e| false }.should == nil
  end

  it "returns the first element for which the block is not false" do
    @elements.each do |element|
      @list.find {|e| e > element - 1 }.should == element
    end
  end

  it "returns the value of the ifnone proc if the block is false" do
    fail_proc = lambda { "cheeseburgers" }
    @list.find(fail_proc) {|e| false }.should == "cheeseburgers"
  end

  it "doesn't call the ifnone proc if an element is found" do
    fail_proc = lambda { raise "This shouldn't have been called" }
    @list.find(fail_proc) {|e| e == @elements.first }.should == 2
  end

  it "calls the ifnone proc only once when the block is false" do
    times = 0
    fail_proc = lambda { times += 1; raise if times > 1; "cheeseburgers" }
    @list.find(fail_proc) {|e| false }.should == "cheeseburgers"
  end

  it "calls the ifnone proc when there are no elements" do
    fail_proc = lambda { "yay" }
    List[].find(fail_proc) {|e| true}.should == "yay"
  end

  it "passes through the values yielded by #each_with_index" do
    visited_elements = []
    List[:a, :b].each_with_index.find { |x, i| visited_elements << [x, i]; nil }
    visited_elements.should == [[:a, 0], [:b, 1]]
  end

  it "returns an enumerator when no block given" do
    @list.find.should be_an_instance_of(Enumerator)
  end

  it "passes the ifnone proc to the enumerator" do
    times = 0
    fail_proc = lambda { times += 1; raise if times > 1; "cheeseburgers" }
    @list.find(fail_proc).each {|e| false }.should == "cheeseburgers"
  end
end