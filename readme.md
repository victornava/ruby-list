# What

This is an implementation of Ruby's Array class. In Ruby and in a sort of functional.

The goal is to implement most of the functionality from Array relying only on the #each method,
like Enumerable does.

Uses Array as internal representation

I'm interested only in immutable methods so methods with the bang "!" are not implemented.

# Why?

- To learn betters ways work with lists
- To explore functional concepts
- For fun

# Goals

- Implement all non-mutable methods
- Don't delegate anything other than each
- Use enumerator rather than array

# Disclamer
I borrowed the tests from the Rubinius project.

# Done

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
- lazy

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
- to_ary
- each_index
- values_at
- sample
- rotate
- assoc
- rassoc
- rindex
- bsearch


# Todo
- &
- |
- *
- +
- -
- combination
- pack
- permutation
- product
- repeated_combination
- repeated_permutation
- transpose
- <=>
- []=
- ::new
- ::try_convert

# Delegated to array
- ::[]
- each
- <<
- ==


# Won't implement
- collect_concat (same as flat_map)
- inject (same as reduce)
- collect (same as map)
- each (delegate to array)
- pop (mutable)
- push (mutable)
- shift (mutable)
- unshift (mutable)
- keep_if (mutable)
- delete_if (mutable)
- delete (mutable)
- delete_at (mutable)
- length (same as size)
- entries (same as to_a)
- detect (same as find)
- find_all (same as select)
- member? (same as include)
- each_entry (same as each)
- clear (mutable)
- concat (mutable)
- insert (mutable)
- replace (mutable)
- to_s (same as inspect)
- index (same as find_index)
- initialize_copy (mutable)
- fill (mutable)
- frozen? (not functionality of array)
- hash (not functionality of array)