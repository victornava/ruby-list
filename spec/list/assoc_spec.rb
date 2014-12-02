require 'spec_helper'

describe "#assoc" do
  it "returns the first list whose 1st item is == obj or nil" do
    s1 = List["colors", "red", "blue", "green"]
    s2 = List[:letters, "a", "b", "c"]
    s3 = List[4]
    s4 = List["colors", "cyan", "yellow", "magenda"]
    s5 = List[:letters, "a", "i", "u"]
    s_nil = List[nil, nil]
    l = List[s1, s2, s3, s4, s5, s_nil]
    l.assoc(s1.first).should equal(s1)
    l.assoc(s2.first).should equal(s2)
    l.assoc(s3.first).should equal(s3)
    l.assoc(s4.first).should equal(s1)
    l.assoc(s5.first).should equal(s2)
    l.assoc(s_nil.first).should equal(s_nil)
    l.assoc(4).should equal(s3)
    l.assoc("key not in array").should be_nil
  end

  it "calls == on first element of each array" do
    key1 = 'it'
    key2 = double('key2')

    items = List[
      List['not it', 1],
      List['it', 2],
      List['na', 3]
    ]

    items.assoc(key1).should equal(items[1])
    items.assoc(key2).should be_nil
  end

  it "ignores any non-List elements" do
    List[1, 2, 3].assoc(2).should be_nil
    s1 = List[4]
    s2 = List[5, 4, 3]
    l = List["foo", List[], s1, s2, nil, List[]]
    l.assoc(s1.first).should equal(s1)
    l.assoc(s2.first).should equal(s2)
  end
end
