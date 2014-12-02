require 'spec_helper'

describe '#*' do
  describe 'with an integer' do
    it 'concatenates n copies of the list when passed an integer' do
      (List[ 1, 2, 3 ] * 0).should == List[]
      (List[ 1, 2, 3 ] * 1).should == List[1, 2, 3]
      (List[ 1, 2, 3 ] * 3).should == List[1, 2, 3, 1, 2, 3, 1, 2, 3]
      (List[] * 10).should == List[]
    end

    it 'does not return self even if the passed integer is 1' do
      list = List[1, 2, 3]
      (list * 1).should_not equal(list)
    end


    it 'raises an ArgumentError when passed a negative integer' do
      lambda { List[ 1, 2, 3 ] * -1 }.should raise_error(ArgumentError)
      lambda { List[] * -1 }.should raise_error(ArgumentError)
    end

    describe 'with a subclass of List' do
      it 'returns a subclass instance' do
        (ListSubclass[1] * 0).should be_an_instance_of(ListSubclass)
        (ListSubclass[1] * 2).should be_an_instance_of(ListSubclass)
      end
    end
  end

  describe 'with a string' do
    it 'behaves like #join' do
      (List[ 1, 2, 3 ] * ',').should == '1,2,3'
      (List[ 'three', 'blue', 'birds' ] * '-').should == 'three-blue-birds'
    end
  end
end


