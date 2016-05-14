require 'spec_helper'

describe "Array#dig" do
  it "returns the nested value specified by the sequence of indexes" do
    a = List[List[1, List[2, 3]]]

    a.dig(0, 1, 1).should == 3
  end

  it "raises a TypeError if any intermediate step does not respond to #dig" do
    a = List[1, 2]

    lambda { a.dig(0, 1) }.should raise_error(TypeError)
  end

  it "raises an ArgumentError if no arguments provided" do
    a = List[]

    lambda { a.dig }.should raise_error(ArgumentError)
  end

  it "returns nil if any intermediate step is nil" do
    a = List[[1, List[2, 3]]]

    a.dig(1, 2, 3).should == nil
  end

  it "calls #dig on any intermediate step with the rest of the sequence as arguments" do
    o = Object.new
    a = List[1, List[2, o]]

    def o.dig(*args)
      {dug: args}
    end

    a.dig(1, 1, :bar, :baz).should == {dug: [:bar, :baz]}
  end
end