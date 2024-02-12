/** Preditive Search
 *
 * A search algorithm based on Binary search which tries to reduce the number of memory accesses.
 * If, on top of knowing that the input is sorted, we assume that it is distributed uniformally,
 * we can then use the first and last object in the range to try and predict where the item we
 * are looking for would be. This means that we would be doing less memory accesses.
 *
 * The formula for the prediction is `indexOf(min) + (max - needle)/(max - min) * (indexOf(max) - indexOf(min))`
 */
module predictivesearch;

import std.traits;
import std.conv;
import std.typecons;

/// find needle in haystack using predictive search
Nullable!size_t find(R, T)(R haystack, T needle)
if(is(typeof((R r, size_t index) {
        T t = r[index];
    })) &&
   is(ReturnType!((R r) => r.length) : size_t) &&
   is(ReturnType!((T t1, T t2, T t3, size_t i1, size_t i2) =>
      cast(size_t)(t3 + (t1 - t2).to!double / (t1 -t3).to!double * (i1 - i2))) : size_t))
{
   alias n_size_t = Nullable!size_t;

   if(haystack.length == 0) return n_size_t.init;
   T min = haystack[0];
   size_t minIndex = 0;
   if(needle == min) return n_size_t(minIndex);
   
   T max = haystack[haystack.length - 1];

   size_t maxIndex = haystack.length - 1;

   if(needle == max) return n_size_t(maxIndex);
   return n_size_t.init;
}

unittest
{
   assert(find([1,2,3,4], 1).get == 0);
}

unittest
{
   assert(find([1, 2, 3, 4], 4).get == 3);
}

unittest
{
   assert(find([1, 2, 3, 4], 5).isNull);
}
