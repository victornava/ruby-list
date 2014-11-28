require 'spec_helper'

describe "#group_by" do
  it "returns an empty hash for empty list" do
    List[].group_by { |x| x}.should == {}
  end

  it "returns a hash with values grouped according to the block" do
    list = List["foo", "bar", "baz"]
    h = list.group_by { |word| word[0..0].to_sym }
    h.should == { :f => List["foo"], :b => List["bar", "baz"]}
  end

  it "returns a hash without default_proc" do
    list = List["foo", "bar", "baz"]
    h = list.group_by { |word| word[0..0].to_sym }
    h[:some].should be_nil
    h.default_proc.should be_nil
    h.default.should be_nil
  end
end