require 'spec_helper'

describe "#zip" do
  it "combines each element of the receiver with the element of the same index in lists given as arguments" do
    List[1,2,3].zip(List[4,5,6], List[7,8,9]).should == List[List[1,4,7], List[2,5,8], List[3,6,9]]
    List[1,2,3].zip.should == List[List[1], List[2], List[3]]
  end

  it "passes each element of the result list to a block and return nil if a block is given" do
    expected = List[List[1,4,7], List[2,5,8], List[3,6,9]]
    List[1,2,3].zip(List[4,5,6], List[7,8,9]) do |result_component|
      result_component.should == expected.first
      expected = expected.drop(1)
    end.should == nil
    expected.size.should == 0
  end

  it "fills resulting list with nils if an argument array is too short" do
    List[1,2,3].zip(List[4,5,6], List[7,8]).should == List[List[1,4,7], List[2,5,8], List[3,6,nil]]
  end

  it "returns an list of lists containing corresponding elements of each list" do
    List[1, 2, 3, 4].zip(List["a", "b", "c", "d", "e"]).should ==
    List[List[1, "a"], List[2, "b"], List[3, "c"], List[4, "d"]]
  end

  it "fills in missing values with nil" do
    List[1, 2, 3, 4, 5].zip(List["a", "b", "c", "d"]).should ==
    List[List[1, "a"], List[2, "b"], List[3, "c"], List[4, "d"], List[5, nil]]
  end

  it "properly handles recursive arrays" do
    a = List[List[]]
    b = List[1, List[1]]

    a.zip(a).should == List[ List[a[0], a[0]] ]
    a.zip(b).should == List[ List[a[0], b[0]] ]
    b.zip(a).should == List[ List[b[0], a[0]], List[b[1], a[1]] ]
    b.zip(b).should == List[ List[b[0], b[0]], List[b[1], b[1]] ]
  end

  # TODO Not sure if I care about this
  # it "calls #to_ary to convert the argument to an Array" do
  #   obj = double('List[3,4]')
  #   obj.should_receive(:to_ary).and_return([3, 4])
  #   List[1, 2].zip(obj).should == List[List[1, 3], List[2, 4]]
  # end
  #
  # it "uses #each to extract arguments' elements when #to_ary fails" do
  #   obj = Class.new do
  #     def each(&b)
  #       [3,4].each(&b)
  #     end
  #   end.new
  #   List[1, 2].zip(obj).should == List[List[1, 3], List[2, 4]]
  # end

  it "calls block if supplied" do
    values = List[]
    List[1, 2, 3, 4].zip(["a", "b", "c", "d", "e"]) { |value|
      values << value
    }.should == nil

    values.should == List[List[1, "a"], List[2, "b"], List[3, "c"], List[4, "d"]]
  end

  it "does not return subclass instance on Array subclasses" do
    ListSubclass[1, 2, 3].zip(List["a", "b"]).should be_an_instance_of(List)
  end
end
