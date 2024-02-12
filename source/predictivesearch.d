/** Preditive Search
 *
 * A search algorithm based on Binary search which tries to reduce the number of memory accesses.
 * If, on top of knowing that the input is sorted, we assume that it is distributed uniformally,
 * we can then use the first and last object in the range to try and predict where the item we
 * are looking for would be. This means that we would be doing less memory accesses
 */
module predictivesearch;

size_t find(R)(R randomAccessRange, T Needle)
if(is(typeof((R r, size_t index) {
        T t = r[index];
    })) && is(typeof((R r) => R[$ - 1]))) // random access ranges have different requirements
{
   return 0; 
}

unittest
{
   assert(find([1,2,3,4], 1) == 0);
}
