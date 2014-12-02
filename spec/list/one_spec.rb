require 'spec_helper'

describe "#one?" do
  describe "when passed a block" do
    it "returns true if block returns true once" do
      List[:a, :b, :c].one? { |s| s == :a }.should be_true
    end

    it "returns false if the block returns true more than once" do
      List[:a, :b, :c].one? { |s| s == :a || s == :b }.should be_false
    end

    it "returns false if the block only returns false" do
      List[:a, :b, :c].one? { |s| s == :d }.should be_false
    end
  end

  describe "when not passed a block" do
    it "returns true if only one element evaluates to true" do
      List[false, nil, true].one?.should be_true
    end

    it "returns false if two elements evaluate to true" do
      List[false, :value, nil, true].one?.should be_false
    end

    it "returns false if all elements evaluate to false" do
      List[false, nil, false].one?.should be_false
    end
  end
end
