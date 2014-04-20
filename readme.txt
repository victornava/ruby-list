# What

This is an implementation or Ruby's Array class

Will use an array as internal representation
The goal is to implement most of the functionality from Array by just using its #each method,
like Enumerable does.

I'm interested only on the immutable methods so all mutable methods with "!" are not implemented.

# Why?

- To learn
- For fun

# Goals

- Implement all the methods
- Don't delegate anything other than each
- Work only with immutable methods internally
- Use enumerator rather than array

# Implemented

map
reduce
count
select
reject
all?
any?
take
size
drop
first
min
min_by
max
max_by
minmax
minmax_by
sort
sort_by
zip
each_with_index
each_with_object
flat_map
to_a
partition
none?
take_while
drop_while
find

# To implement

(From Enumerable)

chunk
cycle
each_cons
each_entry
each_slice
find_all
find_index
grep
group_by
include?
lazy
member?
one?
reverse_each
slice_before
to_h

(From Array)

::new
::try_convert
&
*
+
-
<=>
[]
[]=
assoc
at
bsearch
clear
combination
compact
concat
each_index
empty?
eql?
fetch
fill
flatten
frozen?
hash
index
initialize_copy
insert
inspect
join
last
pack
permutation
product
rassoc
repeated_combination
repeated_permutation
replace
reverse
rindex
rotate
sample
shuffle
slice
to_ary
to_s
transpose
uniq
values_at
|

# Delegated to array
::[]
each
<<
==

# Not implemented
collect_concat (same as flat_map)
inject (same as reduce)
collect (same as map)
each (delegate to array)
pop (mutable)
push (mutable)
shift (mutable)
unshift (mutable)
keep_if (mutable)
delete_if (mutable)
delete (mutable)
delete_at (mutable)
length (same as size)
entries (same as to_a)
detect (same as find)