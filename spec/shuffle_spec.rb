require 'spec_helper'

describe "#shuffle" do
  it "returns the same values, in a usually different order" do
    l = List[1, 2, 3, 4]
    different = false
    10.times do
      s = l.shuffle
      s.sort.should == l
      different ||= (l != s)
    end
    different.should be_true # Will fail once in a blue moon (4!^10)
  end

  it "is not destructive" do
    l = List[1, 2, 3]
    10.times do
      l.shuffle
      l.should == List[1, 2, 3]
    end
  end

  it "does not return subclass instances with List subclass" do
    ListSubclass[1, 2, 3].shuffle.should be_an_instance_of(List)
  end

  it "attempts coercion via #to_hash" do
    obj = double('hash')
    obj.should_receive(:to_hash).once.and_return({})
    List[2, 3].shuffle(obj)
  end

  it "calls #rand on the Object passed by the :random key in the arguments Hash" do
    obj = double("array_shuffle_random")
    obj.should_receive(:rand).at_least(1).times.and_return(0)

    result = List[1, 2].shuffle(:random => obj)
    result.size.should == 2
    result.should include(1, 2)
  end

  it "ignores an Object passed for the RNG if it does not define #rand" do
    obj = double("array_shuffle_random")

    result = List[1, 2].shuffle(:random => obj)
    result.size.should == 2
    result.should include(1, 2)
  end

  it "accepts a Float for the value returned by #rand" do
    random = double("array_shuffle_random")
    random.should_receive(:rand).at_least(1).times.and_return(0.3)

    List[1, 2].shuffle(:random => random).should be_an_instance_of(List)
  end

  it "calls #to_int on the Object returned by #rand" do
    value = double("array_shuffle_random_value")
    value.should_receive(:to_int).at_least(1).times.and_return(0)
    random = double("array_shuffle_random")
    random.should_receive(:rand).at_least(1).times.and_return(value)

    List[1, 2].shuffle(:random => random).should be_an_instance_of(List)
  end

  it "raises a RangeError if the value is less than zero" do
    value = double("array_shuffle_random_value")
    value.should_receive(:to_int).and_return(-1)
    random = double("array_shuffle_random")
    random.should_receive(:rand).and_return(value)

    lambda { [1, 2].shuffle(:random => random) }.should raise_error(RangeError)
  end

  it "raises a RangeError if the value is equal to one" do
    value = double("array_shuffle_random_value")
    value.should_receive(:to_int).at_least(1).times.and_return(1)
    random = double("array_shuffle_random")
    random.should_receive(:rand).at_least(1).times.and_return(value)

    lambda { [1, 2].shuffle(:random => random) }.should raise_error(RangeError)
  end
end