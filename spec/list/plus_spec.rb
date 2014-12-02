require 'spec_helper'

describe "#+" do
  it "concatenates two lists" do
    (List[ 1, 2, 3 ] + List[ 3, 4, 5 ]).should == List[1, 2, 3, 3, 4, 5]
    (List[ 1, 2, 3 ] + List[]).should == List[1, 2, 3]
    (List[] + List[ 1, 2, 3 ]).should == List[1, 2, 3]
    (List[] + List[]).should == List[]
  end

  it "can concatenate an list with itself" do
    list = List[1, 2, 3]
    (list + list).should == List[1, 2, 3, 1, 2, 3]
  end

  it "properly handles recursive lists" do
    empty = ListSpecs.empty_recursive_list
    (empty + empty).should == List[empty, empty]

    list = ListSpecs.recursive_list
    (empty + list).should == List[empty, 1, 'two', 3.0, list, list, list, list, list]
    (list + list).should == List[
      1, 'two', 3.0, list, list, list, list, list,
      1, 'two', 3.0, list, list, list, list, list]
  end

  it "does return subclass instances with List subclasses" do
    (ListSubclass[1, 2, 3] + List[]).should be_an_instance_of(List)
    (ListSubclass[1, 2, 3] + ListSubclass[]).should be_an_instance_of(List)
    (List[1, 2, 3] + ListSubclass[]).should be_an_instance_of(List)
  end


  it "does not get infected even if an original list is tainted" do
    (List[1, 2] + List[3, 4]).tainted?.should be_false
    (List[1, 2].taint + List[3, 4]).tainted?.should be_false
    (List[1, 2] + List[3, 4].taint).tainted?.should be_false
    (List[1, 2].taint + List[3, 4].taint).tainted?.should be_false
  end

  it "does not infected even if an original list is untrusted" do
    (List[1, 2] + List[3, 4]).untrusted?.should be_false
    (List[1, 2].untrust + List[3, 4]).untrusted?.should be_false
    (List[1, 2] + List[3, 4].untrust).untrusted?.should be_false
    (List[1, 2].untrust + List[3, 4].untrust).untrusted?.should be_false
  end
end
