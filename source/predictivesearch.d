/** Preditive Search
 *
 * A search algorithm based on Binary search which tries to reduce the number of memory accesses.
 * If, on top of knowing that the input is sorted, we assume that it is distributed uniformally,
 * we can then use the first and last object in the range to try and predict where the item we
 * are looking for would be. This means that we would be doing less memory accesses.
 *
 * The formula for the prediction is `indexOf(min) + (needle - min)/(max - min) * (indexOf(max) - indexOf(min))`
 */
module predictivesearch;

import std.traits;
import std.conv;
import std.typecons;

/// find needle in haystack using predictive search
Nullable!size_t find(R, T)(R haystack, T needle)
if(is(ReturnType!((R r, T t, size_t index) => r[index] == t) : bool) &&
   is(ReturnType!((R r, T t) => r[0] < t) : bool) &&
   is(ReturnType!((R r, T t) => r[0] > t) : bool) &&
   is(ReturnType!((R r) => r.length) : size_t) &&
   is(ReturnType!((R r, size_t i1, size_t i2) =>
      cast(size_t)(i2 + (r[0] - r[1]).to!double / (r[2] - r[1]).to!double * (i1 - i2))) : size_t))
{
   alias n_size_t = Nullable!size_t;

   if(haystack.length == 0) return n_size_t.init;
   auto min = haystack[0];
   size_t minIndex = 0;
   if(needle == min) return n_size_t(minIndex);
   if(min > needle) return n_size_t.init;
   
   auto max = haystack[haystack.length - 1]; // using length rather than $ to make the interface less restrictive

   size_t maxIndex = haystack.length - 1;

   if(needle == max) return n_size_t(maxIndex);
   if(max < needle) return n_size_t.init;

   while(max != min)
   {
      size_t prediction = cast(size_t)
         (minIndex + (needle - min).to!double / (max - min).to!double * (maxIndex - minIndex));
      // max and min should already have been tested at this point,
      // if predition truncated down to one of them, simply move them in by one.
      if(prediction == minIndex)
      {
         minIndex++;
         min = haystack[minIndex];
         continue;
      }
      if(prediction == maxIndex) // should only happen if max < 0
      {
         maxIndex--;
         max = haystack[maxIndex];
         continue;
      }

      auto actual = haystack[prediction];
      if(actual == needle) return n_size_t(prediction);
      if(actual < needle)
      {
         min = actual;
         minIndex = prediction;
         continue;
      }
      max = actual;
      maxIndex = prediction;
   }
   return n_size_t.init;
}

///
unittest
{
   auto array = [1, 2, 3, 4];
   auto res = find(array, 1);
   assert(!res.isNull);
   assert(res.get == 0);
   res = find(array, 4UL);
   assert(!res.isNull);
   assert(res.get == 3);
   assert(find(array, 5).isNull);
}

///
unittest
{
   auto array = [4, 5, 41, 44, 45, 48, 60, 72, 76,
                  93, 102, 130, 132, 155, 174, 213, 230,
                  247, 258, 266, 266, 272, 282, 304, 315,
                  325, 334, 344, 350, 357, 369, 372, 376,
                  382, 386, 426, 429, 454, 466, 472, 476,
                  477, 478, 484, 508, 529, 539, 551, 571,
                  574, 575, 581, 596, 619, 624, 629, 634,
                  638, 653, 679, 680, 684, 684, 688, 698,
                  729, 731, 746, 761, 762, 769, 779, 791,
                  800, 806, 808, 818, 824, 828, 831, 833,
                  835, 846, 857, 864, 867, 873, 885, 898,
                  900, 918, 926, 936, 938, 941, 960, 977,
                  981, 986, 989];
   auto res = find(array, 155);
   assert(!res.isNull);
   assert(res.get == 13);
   assert(find(array, 819).isNull);
}
