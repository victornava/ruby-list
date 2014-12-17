require 'spec_helper'

describe "#sort" do
  it "returns a new list sorted based on comparing elements with <=>" do
    l = List[1, -2, 3, 9, 1, 5, -5, 1000, -5, 2, -10, 14, 6, 23, 0]
    l.sort.should == List[-10, -5, -5, -2, 0, 1, 1, 2, 3, 5, 6, 9, 14, 23, 1000]
  end

  it "does not affect the original List" do
    a = List[0, 15, 2, 3, 4, 6, 14, 5, 7, 12, 8, 9, 1, 10, 11, 13]
    b = a.sort
    a.should == List[0, 15, 2, 3, 4, 6, 14, 5, 7, 12, 8, 9, 1, 10, 11, 13]
    b.should == List[*(0..15)]
  end

  it "sorts already-sorted Lists" do
    List[*(0..15)].sort.should == List[*(0..15)]
  end

  it "sorts reverse-sorted Lists" do
    List[*(0..15).to_a.reverse].sort.should == List[*(0..15)]
  end

  it "sorts Lists that consist entirely of equal elements" do
    class SortSame
      def ==(other); true; end
      def < (other); true; end
    end

    l = List[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
    l.sort.should == l
    b = List.new(15).map { SortSame.new }
    b.sort.should == b
  end

  it "sorts Lists that consist mostly of equal elements" do
    l = List[1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1]
    l.sort.should == List[0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
  end

  it "does not return self even if the List would be already sorted" do
    l = List[1, 2, 3]
    sorted = l.sort
    sorted.should == l
    sorted.should_not equal(l)
  end

  it "properly handles recursive Lists" do
    empty = ListSpecs.empty_recursive_list
    empty.sort.should == empty

    # TODO No idea why this fails. Maybe there is something wrong with #==
    # list = List[List[]]; list << list
    # list.sort.should == List[List[], list]
  end

  it "does not deal with exceptions raised by unimplemented or incorrect #<=>" do
    o = Object.new

    lambda { List[o, 1].sort }.should raise_error
  end

  it "may take a block which is used to determine the order of objects a and b described as -1, 0 or +1" do
    l = [5, 1, 4, 3, 2]
    l.sort.should == [1, 2, 3, 4, 5]
    l.sort {|x, y| y <=> x}.should == [5, 4, 3, 2, 1]
  end

  it "raises an error when a given block returns nil" do
    lambda { List[1, 2].sort {} }.should raise_error(ArgumentError)
  end

  it "does not call #<=> on contained objects when invoked with a block" do
    List.new(25, UFOSceptic.new ).sort { -1 }.should be_an_instance_of(List)
  end

  it "completes when supplied a block that always returns the same result" do
    l = List[2, 3, 5, 1, 4]
    l.sort {  1 }.should be_an_instance_of(List)
    l.sort {  0 }.should be_an_instance_of(List)
    l.sort { -1 }.should be_an_instance_of(List)
  end

  it "does not freezes self while being sorted" do
    l = List[1, 2, 3]
    l.sort { |x,y| l.frozen?.should == false; x <=> y }
  end

  it "returns the specified value when it would break in the given block" do
    List[1, 2, 3].sort{ break :a }.should == :a
  end

  it "uses the sign of Bignum block results as the sort result" do
    l = List[1, 2, 5, 10, 7, -4, 12]
    begin
      class Bignum;
        alias old_spaceship <=>
        def <=>(other)
          raise
        end
      end
      l.sort {|n, m| (n - m) * (2 ** 200)}.should == List[-4, 1, 2, 5, 7, 10, 12]
    ensure
      class Bignum
        alias <=> old_spaceship
      end
    end
  end

  it "compares values returned by block with 0" do
    l = List[1, 2, 5, 10, 7, -4, 12]
    target = List[-4, 1, 2, 5, 7, 10, 12]
    l.sort { |n, m| n - m }.should == target
    lambda {
      l.sort { |n, m| (n - m).to_s }
    }.should raise_error(ArgumentError)
  end


  it "raises an error if objects can't be compared" do
    lambda { List[1, 'a'].sort }.should raise_error(ArgumentError)
  end

  it "does not return subclass instance on List subclasses" do
    subclass = ListSubclass[1, 2, 3]
    subclass.sort.should be_an_instance_of(List)
  end
end
