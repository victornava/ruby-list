require 'spec_helper'

describe "::[]" do
  it "returns a new array populated with the given elements" do
    obj = Object.new
    List[5, true, nil, 'a', "Ruby", obj].to_a.should == [5, true, nil, "a", "Ruby", obj]
  end
end