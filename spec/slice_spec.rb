require 'spec_helper'

describe "#slice" do
  it "returns the element at index with List[index]" do
    List[ "a", "b", "c", "d", "e" ].slice(1).should == "b"

    l = List[1, 2, 3, 4]

    l.slice(0).should == 1
    l.slice(1).should == 2
    l.slice(2).should == 3
    l.slice(3).should == 4
    l.slice(4).should == nil
    l.slice(10).should == nil

    l.should == List[1, 2, 3, 4]
  end

  it "returns the element at index from the end of the list with List[-index]" do
    List[ "a", "b", "c", "d", "e" ].slice(-2).should == "d"

    l = List[1, 2, 3, 4]

    l.slice(-1).should == 4
    l.slice(-2).should == 3
    l.slice(-3).should == 2
    l.slice(-4).should == 1
    l.slice(-5).should == nil
    l.slice(-10).should == nil

    l.should == List[1, 2, 3, 4]
  end

  it "returns count elements starting from index with List[index, count]" do
    List[ "a", "b", "c", "d", "e" ].slice(2, 3).should == List["c", "d", "e"]

    l = List[1, 2, 3, 4]

    l.slice(0, 0).should == List[]
    l.slice(0, 1).should == List[1]
    l.slice(0, 2).should == List[1, 2]
    l.slice(0, 4).should == List[1, 2, 3, 4]
    l.slice(0, 6).should == List[1, 2, 3, 4]
    l.slice(0, -1).should == nil
    l.slice(0, -2).should == nil
    l.slice(0, -4).should == nil

    l.slice(2, 0).should == List[]
    l.slice(2, 1).should == List[3]
    l.slice(2, 2).should == List[3, 4]
    l.slice(2, 4).should == List[3, 4]
    l.slice(2, -1).should == nil

    l.slice(4, 0).should == List[]
    l.slice(4, 2).should == List[]
    l.slice(4, -1).should == nil

    l.slice(5, 0).should == nil
    l.slice(5, 2).should == nil
    l.slice(5, -1).should == nil

    l.slice(6, 0).should == nil
    l.slice(6, 2).should == nil
    l.slice(6, -1).should == nil

    l.should == List[1, 2, 3, 4]
  end

  it "returns count elements starting at index from the end of list with List[-index, count]" do
    List[ "a", "b", "c", "d", "e" ].slice(-2, 2).should == List["d", "e"]

    a = List[1, 2, 3, 4]

    a.slice(-1, 0).should == List[]
    a.slice(-1, 1).should == List[4]
    a.slice(-1, 2).should == List[4]
    a.slice(-1, -1).should == nil

    a.slice(-2, 0).should == List[]
    a.slice(-2, 1).should == List[3]
    a.slice(-2, 2).should == List[3, 4]
    a.slice(-2, 4).should == List[3, 4]
    a.slice(-2, -1).should == nil

    a.slice(-4, 0).should == List[]
    a.slice(-4, 1).should == List[1]
    a.slice(-4, 2).should == List[1, 2]
    a.slice(-4, 4).should == List[1, 2, 3, 4]
    a.slice(-4, 6).should == List[1, 2, 3, 4]
    a.slice(-4, -1).should == nil

    a.slice(-5, 0).should == nil
    a.slice(-5, 1).should == nil
    a.slice(-5, 10).should == nil
    a.slice(-5, -1).should == nil

    a.should == List[1, 2, 3, 4]
  end

  it "returns the first count elements with List[0, count]" do
    List[ "a", "b", "c", "d", "e" ].slice(0, 3).should == List["a", "b", "c"]
  end

  it "tries to convert the passed argument to an Integer using #to_int" do
    obj = double('to_int')
    obj.stub(:to_int).and_return(2)

    a = List[1, 2, 3, 4]
    a.slice(obj).should == 3
    a.slice(obj, 1).should == List[3]
    a.slice(obj, obj).should == List[3, 4]
    a.slice(0, obj).should == List[1, 2]
  end

  it "returns the elements specified by Range indexes with List[m..n]" do
    List[ "a", "b", "c", "d", "e" ].slice(1..3).should == List["b", "c", "d"]
    List[ "a", "b", "c", "d", "e" ].slice(4..-1).should == List['e']
    List[ "a", "b", "c", "d", "e" ].slice(3..3).should == List['d']
    List[ "a", "b", "c", "d", "e" ].slice(3..-2).should == List['d']
    List['a'].slice(0..-1).should == List['a']

    a = List[1, 2, 3, 4]

    a.slice(0..-10).should == List[]
    a.slice(0..0).should == List[1]
    a.slice(0..1).should == List[1, 2]
    a.slice(0..2).should == List[1, 2, 3]
    a.slice(0..3).should == List[1, 2, 3, 4]
    a.slice(0..4).should == List[1, 2, 3, 4]
    a.slice(0..10).should == List[1, 2, 3, 4]

    a.slice(2..-10).should == List[]
    a.slice(2..0).should == List[]
    a.slice(2..2).should == List[3]
    a.slice(2..3).should == List[3, 4]
    a.slice(2..4).should == List[3, 4]

    a.slice(3..0).should == List[]
    a.slice(3..3).should == List[4]
    a.slice(3..4).should == List[4]

    a.slice(4..0).should == List[]
    a.slice(4..4).should == List[]
    a.slice(4..5).should == List[]

    a.slice(5..0).should == nil
    a.slice(5..5).should == nil
    a.slice(5..6).should == nil

    a.should == List[1, 2, 3, 4]
  end

  it "returns elements that exist if range start is in the list but range end is not with List[m..n]" do
    List[ "a", "b", "c", "d", "e" ].slice(4..7).should == List["e"]
  end

  it "accepts Range instances having a negative m and both signs for n with List[m..n]" do
    a = List[1, 2, 3, 4]

    a.slice(-1..-1).should == List[4]
    a.slice(-1..3).should == List[4]
    a.slice(-1..4).should == List[4]
    a.slice(-1..10).should == List[4]
    a.slice(-1..0).should == List[]
    a.slice(-1..-4).should == List[]
    a.slice(-1..-6).should == List[]
    a.slice(-2..-2).should == List[3]
    a.slice(-2..-1).should == List[3, 4]
    a.slice(-2..10).should == List[3, 4]
    a.slice(-4..-4).should == List[1]
    a.slice(-4..-2).should == List[1, 2, 3]
    a.slice(-4..-1).should == List[1, 2, 3, 4]
    a.slice(-4..3).should == List[1, 2, 3, 4]
    a.slice(-4..4).should == List[1, 2, 3, 4]
    a.slice(-4..0).should == List[1]
    a.slice(-4..1).should == List[1, 2]
    a.slice(-5..-5).should == nil
    a.slice(-5..-4).should == nil
    a.slice(-5..-1).should == nil
    a.slice(-5..10).should == nil

    a.should == List[1, 2, 3, 4]
  end

  it "returns elements specified by Range indexes except the element at index n with List[m...n]" do
    List[ "a", "b", "c", "d", "e" ].slice(1...3).should == List["b", "c"]

    a = List[1, 2, 3, 4]

    a.slice(0...-10).should == List[]
    a.slice(0...0).should == List[]
    a.slice(0...1).should == List[1]
    a.slice(0...2).should == List[1, 2]
    a.slice(0...3).should == List[1, 2, 3]
    a.slice(0...4).should == List[1, 2, 3, 4]
    a.slice(0...10).should == List[1, 2, 3, 4]

    a.slice(2...-10).should == List[]
    a.slice(2...0).should == List[]
    a.slice(2...2).should == List[]
    a.slice(2...3).should == List[3]
    a.slice(2...4).should == List[3, 4]

    a.slice(3...0).should == List[]
    a.slice(3...3).should == List[]
    a.slice(3...4).should == List[4]

    a.slice(4...0).should == List[]
    a.slice(4...4).should == List[]
    a.slice(4...5).should == List[]

    a.slice(5...0).should == nil
    a.slice(5...5).should == nil
    a.slice(5...6).should == nil

    a.should == List[1, 2, 3, 4]
  end

  it "accepts Range instances having a negative m and both signs for n with List[m...n]" do
    a = List[1, 2, 3, 4]

    a.slice(-1...-1).should == List[]
    a.slice(-1...3).should == List[]
    a.slice(-1...4).should == List[4]
    a.slice(-1...10).should == List[4]
    a.slice(-1...-4).should == List[]
    a.slice(-1...-6).should == List[]
    a.slice(-2...-2).should == List[]
    a.slice(-2...-1).should == List[3]
    a.slice(-2...10).should == List[3, 4]
    a.slice(-4...-2).should == List[1, 2]
    a.slice(-4...-1).should == List[1, 2, 3]
    a.slice(-4...3).should == List[1, 2, 3]
    a.slice(-4...4).should == List[1, 2, 3, 4]
    a.slice(-4...4).should == List[1, 2, 3, 4]
    a.slice(-4...0).should == List[]
    a.slice(-4...1).should == List[1]
    a.slice(-5...-5).should == nil

    a.should == List[1, 2, 3, 4]
  end


  it "tries to convert Range elements to Integers using #to_int with List[m..n] and List[m...n]" do
    from = double('from')
    to = double('to')

    # So we can construct a range out of them...
    def from.<=>(o) 0 end
    def to.<=>(o) 0 end

    def from.to_int() 1 end
    def to.to_int() -2 end

    l = List[1, 2, 3, 4]

    l.slice(from..to).should == List[2, 3]
    l.slice(from...to).should == List[2]
    l.slice(1..0).should == List[]
    l.slice(1...0).should == List[]

    lambda { l.slice("a" .. "b") }.should raise_error(TypeError)
    lambda { l.slice("a" ... "b") }.should raise_error(TypeError)
    lambda { l.slice(from .. "b") }.should raise_error(TypeError)
    lambda { l.slice(from ... "b") }.should raise_error(TypeError)
  end


  it "returns nil for a requested index not in the list with List[index]" do
    List[ "a", "b", "c", "d", "e" ].slice(5).should == nil
  end

  it "returns List[] if the index is valid but length is zero with List[index, length]" do
    List[ "a", "b", "c", "d", "e" ].slice(0, 0).should == List[]
    List[ "a", "b", "c", "d", "e" ].slice(2, 0).should == List[]
  end

  it "returns nil if length is zero but index is invalid with List[index, length]" do
    List[ "a", "b", "c", "d", "e" ].slice(100, 0).should == nil
    List[ "a", "b", "c", "d", "e" ].slice(-50, 0).should == nil
  end

  # This is by design. It is in the official documentation.
  it "returns List[] if index == list.size with List[index, length]" do
    List[*%w|a b c d e|].slice(5, 2).should == List[]
  end

  it "returns nil if index > list.size with List[index, length]" do
    List[*%w|a b c d e|].slice(6, 2).should == nil
  end

  it "returns nil if length is negative with List[index, length]" do
    List[*%w|a b c d e|].slice(3, -1).should == nil
    List[*%w|a b c d e|].slice(2, -2).should == nil
    List[*%w|a b c d e|].slice(1, -100).should == nil
  end

  it "returns nil if no requested index is in the list with List[m..n]" do
    List[ "a", "b", "c", "d", "e" ].slice(6..10).should == nil
  end

  it "returns nil if range start is not in the list with List[m..n]" do
    List[ "a", "b", "c", "d", "e" ].slice(-10..2).should == nil
    List[ "a", "b", "c", "d", "e" ].slice(10..12).should == nil
  end

  it "returns an empty list when m == n with List[m...n]" do
    List[1, 2, 3, 4, 5].slice(1...1).should == List[]
  end

  it "returns an empty list with List[0...0]" do
    List[1, 2, 3, 4, 5].slice(0...0).should == List[]
  end

  it "returns a sublist where m, n negatives and m < n with List[m..n]" do
    List[ "a", "b", "c", "d", "e" ].slice(-3..-2).should == List["c", "d"]
  end

  it "returns an list containing the first element with List[0..0]" do
    List[1, 2, 3, 4, 5].slice(0..0).should == List[1]
  end

  it "returns the entire list with List[0..-1]" do
    List[1, 2, 3, 4, 5].slice(0..-1).should == List[1, 2, 3, 4, 5]
  end

  it "returns all but the last element with List[0...-1]" do
    List[1, 2, 3, 4, 5].slice(0...-1).should == List[1, 2, 3, 4]
  end

  it "returns List[3] for List[2..-1] out of List[1, 2, 3]" do
    List[1,2,3].slice(2..-1).should == List[3]
  end

  it "returns an empty list when m > n and m, n are positive with List[m..n]" do
    List[1, 2, 3, 4, 5].slice(3..2).should == List[]
  end

  it "returns an empty list when m > n and m, n are negative with List[m..n]" do
    List[1, 2, 3, 4, 5].slice(-2..-3).should == List[]
  end

  it "does not expand list when the indices are outside of the list bounds" do
    l = List[1, 2]
    l.slice(4).should == nil
    l.should == List[1, 2]
    l.slice(4, 0).should == nil
    l.should == List[1, 2]
    l.slice(6, 1).should == nil
    l.should == List[1, 2]
    l.slice(8...8).should == nil
    l.should == List[1, 2]
    l.slice(10..10).should == nil
    l.should == List[1, 2]
  end

  describe "with a subclass of List" do
    before :each do
      @list = ListSubclass[1, 2, 3, 4, 5]
    end

    it "returns a subclass instance with List[n, m]" do
      @list.slice(0, 2).should be_an_instance_of(ListSubclass)
    end

    it "returns a subclass instance with List[-n, m]" do
      @list.slice(-3, 2).should be_an_instance_of(ListSubclass)
    end

    it "returns a subclass instance with List[n..m]" do
      @list.slice(1..3).should be_an_instance_of(ListSubclass)
    end

    it "returns a subclass instance with List[n...m]" do
      @list.slice(1...3).should be_an_instance_of(ListSubclass)
    end

    it "returns a subclass instance with List[-n..-m]" do
      @list.slice(-3..-1).should be_an_instance_of(ListSubclass)
    end

    it "returns a subclass instance with List[-n...-m]" do
      @list.slice(-3...-1).should be_an_instance_of(ListSubclass)
    end
  end
end
