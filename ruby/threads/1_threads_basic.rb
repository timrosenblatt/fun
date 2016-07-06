#!/usr/bin/env ruby -w

# From http://rubylearning.com/satishtalim/ruby_threads.html

x = Thread.new do
  sleep 0.1
  print "x"
  print "y"
  print "z"
end

a = Thread.new do
  print "a"
  print "b"
  sleep 0.2
  print "c"
end

x.join
a.join
