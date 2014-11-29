require 'spec_helper'

describe "#sample" do
  it "passes the size of the List to the object passed with :random" do
    obj = double("list_sample_random")
    obj.should_receive(:rand).with(3).and_return(0)

    List[1, 2, 3].sample(:random => obj).should be_an_instance_of(Fixnum)
  end

  it "works without arguments" do
    List[3,4,5,6,7,8].sample.between?(3,8).should be_true
  end
end
