require 'spec_helper'

describe "#each" do
  it "delegates to Array" do
    List[1,2].each.inspect.should  == [1,2].each.inspect
  end
end