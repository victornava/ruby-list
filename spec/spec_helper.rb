require 'list'

RSpec.configure do |config|
  # Use color in STDOUT
  config.color_enabled = true

  # Use color not only in STDOUT but also in pagers and files
  config.tty = true

  # Use the specified formatter
  config.formatter = :progress
end

class ListSubclass < List ; end

class ListSpecs
  # SampleRange = 0..1000
  # SampleCount = 1000

  # def self.frozen_list
  #   frozen_list = [1,2,3]
  #   frozen_list.freeze
  #   frozen_list
  # end
  #
  # def self.empty_frozen_list
  #   frozen_list = []
  #   frozen_list.freeze
  #   frozen_list
  # end

  def self.recursive_list
    a = List[1, 'two', 3.0]
    5.times { a << a }
    a
  end

  def self.head_recursive_list
    a =  List[]
    5.times { a << a }
    a << 1 << 'two' << 3.0
    a
  end

  def self.empty_recursive_list
    a = List[]
    a << a
    a
  end

  def self.numerous
    List[2, 5, 3, 6, 1, 4]
  end
end
