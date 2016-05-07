#!/usr/bin/env ruby -w

Node = Struct.new(:value, :next)

class List
  # Could probably upgrade this by making it accept an array
  # as input and creating an initial list from that.
  def initialize(value:)
    @head = Node.new(value, nil)
  end

  def to_s
    if @head.nil? || @head.value.nil?
      "[empty list]"
    end

    output = "#{@head.value}, "

    return output if @head.next.nil?

    temp = @head.next
    while !temp.nil?
      output += "#{temp.value}, "
      temp = temp.next
    end

    output
  end

  def add(value:)
    end_of_list.next = Node.new(value, nil)
  end

  # Deliberately calling this end_of_list to avoid
  # using a keyword as a function name (ie: calling it 'end')
  def end_of_list
    temp = @head

    while !temp.next.nil?
      temp = temp.next
    end

    temp
  end

  # Just a simple delete based on value
  def delete(value:)
    if @head.value == value
      if @head.next.nil?
        @head.value = nil
        return value
      else
        @head = @head.next
        return value
      end
    else
      prev = @head
      temp = @head.next

      while !temp.nil?
        if temp.value == value
          prev.next = temp.next
          return value
        end

        prev = temp
        temp = temp.next
      end
    end

    return false # Not great to return different types but this is for fun
  end

  def [](index)
    temp = @head

    index.times do
      if temp.next.nil?
        return "[input val longer than list]"
      else
        temp = temp.next
      end
    end

    temp.value
  end

  # in place
  def reverse
    # base case -- a list of 0
    if @head.nil?
      puts "[empty list]"
    elsif @head.next.nil? # list is only 1 element long
      return # nothing to do
    else # list is more than one element
      prev = nil
      next_node = @head.next

      while !next_node.nil?
        @head.next = prev
        prev = @head
        @head = next_node
        next_node = next_node.next
      end

      @head.next = prev
    end
  end
end

list = List.new value: 'a'

puts list
list.reverse
puts list
list.add value: 'b'
puts list
list.reverse
puts list
list.add value: 'c'
puts list
list.reverse
puts list
list.add value: 'd'
puts list
list.reverse
puts list
puts "==="

puts list[0]
puts list[1]
puts list[2]
puts list[3]
puts list[4]
puts list[5]
