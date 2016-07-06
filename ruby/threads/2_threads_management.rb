#!/usr/bin/env ruby -w

# From http://rubylearning.com/satishtalim/ruby_threads.html

# Listing threads always shows one more than the number that have been
# created -- the extra thread is the main thread that the program is
# running in

puts Thread.main
puts ""
t1 = Thread.new {sleep 100}

puts "List of all current threads, after only making one:"
Thread.list.each {|thr| p thr }
puts "Current thread = " + Thread.current.to_s
puts ""

t2 = Thread.new {sleep 100}
puts "List of all threads after making two:"
Thread.list.each {|thr| p thr }

puts Thread.current
puts ""

puts "Killing thread 1"
Thread.kill(t1)


Thread.pass                          # pass execution to t2 now
t3 = Thread.new do
  sleep 20
  Thread.exit                        # exit the thread
end
Thread.kill(t2)                      # now kill t2

puts "Listing all threads, there should be only one, the third"
Thread.list.each {|thr| p thr }

# now exit the main thread (killing any others)
Thread.exit
