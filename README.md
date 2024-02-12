# PredictiveSearch
A searching algorithm which may be faster than binary search

(this depends on your architecture, as it reduces array accesses in exchange for extra branches)

If you've ever been told that binary search is theoretically optimal: this would be the counter-proof.

Both algorithms work on average in O(log(n)) time,
but this one is more likely to get the value on the first (or rather third) try.

It works on the requirement that the data is sorted and on the assumption that it is uniformally distributed.
This should still be comparable to or better than binary search for most arrays, as even if it isn't uniformally
distributed, if it is random, then subarrays will increasingly be closer to a uniform distribution as their size decreases.

Of course, it is possible to generate an array where this devolves into linear search
but in general, it shouldn't happen.
