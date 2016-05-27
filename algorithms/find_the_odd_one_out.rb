#!/usr/bin/env ruby -w

# The goal here is to take an array that has pairs of elements,
# and a single element that has no matching pair, so:
#   [1, 1, 2, 2, 3]
# 3 is the odd one out.

# Thought this was a clever one. Because xor-ing two of the same
# number results in 0, you can xor the entire array into an
# accumulator and at the end it will contain the value that doesn't
# have a match.

# Obviously this has no error handling, no bounds checking,
# and only works for positive integers. But, it's a cool technique.

accumulator = 0

[1, 1, 2, 2, 3].each do |i|
  accumulator ^= i
end

puts accumulator
