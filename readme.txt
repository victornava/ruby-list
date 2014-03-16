# What

This is an implementation or Ruby's Array class

Will use an array as internal representation
The goal is to copy all the functionality of Array by just using the #each method

# Why?

- To learn
- For fun

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


# To implement

(From Enumerable)

chunk
cycle
detect
drop_while
each_cons
each_entry
each_slice
each_with_index
each_with_object
entries
find
find_all
find_index
flat_map
grep
group_by
include?
lazy
max
max_by
member?
min_by
minmax
minmax_by
none?
one?
partition
reverse_each
slice_before
sort
sort_by
take_while
to_a
to_h
zip

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