require 'spec_helper'

describe "List.try_convert" do
  it "returns the argument if it's an List" do
    x = List.new
    List.try_convert(x).should equal(x)
  end

  it "returns the argument if it's a kind of List" do
    x = ListSubclass.new
    List.try_convert(x).should equal(x)
  end

  it "returns nil when the argument does not respond to #to_ary" do
    List.try_convert(Object.new).should be_nil
  end

  it "sends #to_ary to the argument and returns the result if it's nil" do
    obj = double("to_ary")
    obj.should_receive(:to_ary).and_return(nil)
    List.try_convert(obj).should be_nil
  end

  it "sends #to_ary to the argument and returns the result if it's an Array" do
    obj = double("to_ary")
    obj.should_receive(:to_ary).and_return([])
    List.try_convert(obj).should == List[]
  end

  it "sends #to_ary to the argument and raises TypeError if it's not a kind of List" do
    obj = double("to_ary")
    obj.should_receive(:to_ary).and_return(Object.new)
    lambda { List.try_convert obj }.should raise_error(TypeError)
  end

  it "does not rescue exceptions raised by #to_ary" do
    obj = double("to_ary")
    obj.should_receive(:to_ary).and_raise(RuntimeError)
    lambda { List.try_convert obj }.should raise_error(RuntimeError)
  end
end