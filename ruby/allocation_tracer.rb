require 'allocation_tracer'
require 'pp'

# https://github.com/ko1/allocation_tracer
# For watching how Ruby code performs.

# The output from #trace is a hash where
# the key is the file name and line number,
# and the value is
# [ number of objects created,
#   old objects,
#   total age of objects
#   minimum age,
#   maximum age
#   total memory consumption without RVALUE ]

pp ObjectSpace::AllocationTracer.trace{
  50_000.times{|i|
    i.to_s
    i.to_s
    i.to_s
  }
}


p allocated: ObjectSpace::AllocationTracer.allocated_count_table
p freed: ObjectSpace::AllocationTracer.freed_count_table
