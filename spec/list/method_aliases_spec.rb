require 'spec_helper'

describe 'method aliases' do
  it 'respond to this methods' do
    methods = [
      :collect_concat,
      :inject,
      :collect,
      :length,
      :entries,
      :detect,
      :find_all,
      :member?,
      :each_entry,
      :to_s,
      :index
    ]

    methods.each do |method|
      List[].respond_to?(method).should be_true, "should respond to #{method}"
    end
  end
end
