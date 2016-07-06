There is no parent-child relationship between threads. There's only the main thread, and then additional threads that have been spawned. A spawned thread can spawn it's own, but those are sibling threads, not child threads. In Ruby, this intuitively makes sense, because Thread::list returns a 1-dimensional array, not some kind of tree structure.

My mental model for exclusion is database transactions. Basically -- there's some amount of code that needs to be run atomically on a shared resource, and no other process should be allowed to do anything to the shared resource until the atomic unit is completed. I think the important thing in writing mutex code is that the author needs to be careful to only do small amounts of computation so that other threads don't get starved for CPU time.

How much manual thread management am I responsible for as the programmer? Is this why thread pools are so valuable?

Should I always use `pass` to hint to the thread scheduler? What happens if I don't?
