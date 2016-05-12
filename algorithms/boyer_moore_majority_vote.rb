#!/usr/bin/env ruby -w

# majority vote is the idea of finding the number in a set
# that occurs at least half the time
#
# [1, 1, 1, 1, 3, 4, 5] -- the number is 1
# [1, 2, 3, 4, 5] -- none
#
# it's not about which element occurs the most -- it's specifically which
# element occurs at least half the time.
# The nature of the problem ensures that there's only one possible number
# that meets this criteria per set, if any, since it is obviously impossible
# for more than one number to have more than half the occurrences in a set.

def bm_vote(input)
  return nil if input.nil? || input.length == 0

  candidate = nil
  count = 0

  input.each do |item|
    if count == 0
      candidate = item
      count = 1
      next
    elsif candidate == item
      count += 1
    else
      count -= 1
    end
  end

  return nil if count == 0

  # It's not clear to me why I can't cut it off at this point.
  # I was poking around on paper trying to construct an array
  # that would result in count being anything other than 0 by this point
  # and it not being the majority element.
  # Certianly it can't be negative at this point.

  count = 0
  input.each do |item|
    if candidate == item
      count += 1
    end
  end

  return count > input.length / 2 ? candidate : nil
end

puts bm_vote([1, 1, 1, 1, 3, 4, 5]) == 1 ? 'worked' : 'failed'
puts bm_vote([1, 2, 3, 4, 5]).nil? ? 'worked' : 'failed'
