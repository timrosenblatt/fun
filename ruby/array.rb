#!/usr/bin/env ruby -w

require 'rubygems'
require 'pp'

# create multidimensional Array with default value in one line
pp Array.new(3) { Array.new(4, 0) }


# prefer fetch, as it raises an error instead of []
a = Array.new 3
puts "The dog's name is #{a[10]}"

begin
  puts "The dog's name is #{a.fetch 10}"
rescue IndexError
  puts 'gotcha'
end


# working with batches

a = [0, 1, 2, 3, 4, 5]
puts a.take 2
puts '--'
puts a.drop 4
