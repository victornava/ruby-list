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


# To implement 

(From Enumerable)

chunk
cycle
detect
drop
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
first
flat_map
grep
group_by
include?
lazy
max
max_by
member?
min
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
take
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
delete
delete_at
delete_if
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
keep_if
last
length
pack
permutation
pop
product
push
rassoc
repeated_combination
repeated_permutation
replace
reverse
rindex
rotate
sample
shift
shuffle
size
slice
to_ary
to_s
transpose
uniq
unshift
values_at
|

Only non destructive methods are implemented
Methods to implement

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