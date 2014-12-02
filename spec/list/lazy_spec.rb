require 'spec_helper'

describe "#lazy" do
  true.should == true
  List[].lazy.kind_of?(Enumerator::Lazy).should == true
end