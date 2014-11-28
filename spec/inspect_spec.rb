require 'spec_helper'

describe "#inspect" do
  it "returns a string" do
    List[1, 2, 3].inspect.should be_an_instance_of(String)
  end

  it "returns '[]' for an empty List" do
    List[].inspect.should == "[]"
  end

  it "calls inspect on its elements and joins the results with commas" do
    List[0, 1, 2].inspect.should == "[0, 1, 2]"
  end

  it "represents a recursive element with '[...]'" do
    ListSpecs.recursive_list.inspect.should == "[1, \"two\", 3.0, [...], [...], [...], [...], [...]]"
    ListSpecs.head_recursive_list.inspect.should == "[[...], [...], [...], [...], [...], 1, \"two\", 3.0]"
    ListSpecs.empty_recursive_list.inspect.should == "[[...]]"
  end
end