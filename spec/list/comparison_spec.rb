require 'spec_helper'

describe "#<=>" do
  it "calls <=> left to right and return first non-0 result" do
    List[-1, +1, nil, "foobar"].each do |result|
      lhs = List[double("#{result}"), double("#{result}"), double("#{result}")]
      rhs = List[double("#{result}"), double("#{result}"), double("#{result}")]

      lhs[0].should_receive(:<=>).with(rhs[0]).and_return(0)
      lhs[1].should_receive(:<=>).with(rhs[1]).and_return(result)
      lhs[2].should_not_receive(:<=>)

      (lhs <=> rhs).should == result
    end
  end

  it "returns 0 if the list are equal" do
    (List[] <=> List[]).should == 0
    (List[1, 2, 3, 4, 5, 6] <=> List[1, 2, 3, 4, 5.0, 6.0]).should == 0
  end

  it "returns -1 if the list is shorter than the other list" do
    (List[] <=> List[1]).should == -1
    (List[1, 1] <=> List[1, 1, 1]).should == -1
  end

  it "returns +1 if the list is longer than the other list" do
    (List[1] <=> List[]).should == 1
    (List[1, 1, 1] <=> List[1, 1]).should == 1
  end

  it "returns -1 if the lists have same length and a pair of corresponding elements returns -1 for <=>" do
    ( List[1, 1, 0, 4] <=> List[1, 1, 2, 4]).should == -1
  end

  it "returns +1 if the lists have same length and a pair of corresponding elements returns +1 for <=>" do
    lhs = List[1, 1, 2, 4]
    rhs = List[1, 1, 0, 4]

    (lhs <=> rhs).should == 1
  end
end