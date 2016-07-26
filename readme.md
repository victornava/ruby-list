# What

This is a naive implementation of Ruby's Array class. In Ruby and in a sort of functional way.

The goal is to implement most of the functionality from Array relying only on the #each method,
like Enumerable does.

Uses Array as internal representation

I'm interested only in immutable methods so methods with the bang "!" are not implemented.


# Why?

- To learn betters ways work with lists
- To explore functional concepts
- Fun


# Goals

- Implement all non-mutable methods
- Don't delegate anything to array other than each

# Running the tests

    $ bundle exec rspec spec/list

# Disclamer

Tests adapted from [Rubinius](https://github.com/rubinius/rubinius/tree/master/spec/ruby/core/array)

# TODO


- sum

# Implemented Methods

(From Enumerable)

- map
- reduce
- count
- select
- reject
- all?
- any?
- take
- size
- drop
- first
- min
- min_by
- max
- max_by
- minmax
- minmax_by
- sort
- sort_by
- zip
- each_with_index
- each_with_object
- flat_map
- to_a
- partition
- none?
- take_while
- drop_while
- find
- include?
- one?
- find_index
- grep
- reverse_each
- each_cons
- each_slice
- slice_before
- chunk
- cycle
- group_by
- lazy (Not really)
- dig

(From Array)

- reverse
- last
- empty?
- uniq
- compact
- join
- flatten
- shuffle
- inspect
- eql?
- at
- fetch
- slice
- []
- each_index
- values_at
- sample
- rotate
- assoc
- rassoc
- rindex
- bsearch
- &
- |
- +
- -
- *
- product
- combination
- repeated_combination
- <=>
- repeated_permutation
- permutation
- ::new
- ::try_convert
- ::[]
- collect_concat
- inject
- collect
- length
- entries
- detect
- find_all
- member?
- each_entry
- to_s
- index
- ==
- transpose
- dig
- slice_when
- chunk_while

# Delegated to Array

- each
- to_ary
- <<


# Won't implement

- pop (mutable)
- push (mutable)
- shift (mutable)
- unshift (mutable)
- keep_if (mutable)
- delete_if (mutable)
- delete (mutable)
- delete_at (mutable)
- clear (mutable)
- concat (mutable)
- insert (mutable)
- replace (mutable)
- initialize_copy (mutable)
- fill (mutable)
- frozen? (not functionality of array)
- hash (not functionality of array)
- pack (binary stuff)
- []= (mutable)