#!/usr/bin/env ruby -w

puts "make a max heap that works in an array"

class MaxHeap
  def to_s
    @heap.inspect
  end

  def initialize
    @heap = []
  end

  def add(new_value)
    new_value_index = @heap.length
    @heap << new_value

    height = height_of_index(new_value_index)

    child_index = new_value_index
    child_value = new_value

    parent_index = parent_index_of(child_index)
    parent_value = @heap[parent_index]

# puts "BEFORE SWAPPING"
# puts "pv #{parent_value}; pi #{parent_index}; cv #{child_value}; ci #{child_index}\n\n"

    (0..height).each do
      if parent_value < child_value
        swap(parent_index, child_index)
      else
        break
      end

      child_index = parent_index
      child_value = @heap[parent_index] # using parent_index because the swap happpened

      parent_index = parent_index_of(parent_index)
      parent_value = @heap[parent_index]
    end
  end

  # Always happens at head
  def delete
    # Step 1 − Remove root node.
    # Step 2 − Move the last element of last level to root.
    tail_value = @heap.pop
    @heap[0] = tail_value

    parent_index = 0

    while(child_exists?(parent_index)) do
      if left_child_exists?(parent_index)
        # left child exists and needs to be swapped, swap
      elsif right_child_exists?(parent_index)
        #  right child exists and needs to be swapped, swap
      end
    end

    # Step 3 − Compare the value of this child node with its parent.
    # Step 4 − If value of parent is less than child, then swap them.
    # Step 5 − Repeat step 3 & 4 until Heap property holds.
  end

  private

  def child_exists?(index)
    left_child_exists?(index) || right_child_exists?(index)
  end

  def left_child_exists?(index)
    !@heap[left_child_index(index)].nil?
  end

  def left_child_index(index)
    2 * index + 1
  end

  def right_child_index(index)
    2 * index + 2
  end

  def right_child_exists?(index)
    !@heap[right_child_index(index)].nil?
  end

  def swap(index1, index2)
    temp = @heap[index1]
    @heap[index1] = @heap[index2]
    @heap[index2] = temp
  end

  def height_of_index(index)
    if(index == 0)
      return 0
    else
      parent_index = parent_index_of(index)
      return 1 + height_of_index(parent_index)
    end
  end

  def parent_index_of(index)
    return 0 if index == 0

    left = index % 2 # is this the left or right child of the parent

    if(left == 1)
      (index - 1) / 2
    else
      (index - 2) / 2
    end
  end
end

mh = MaxHeap.new

(0..10).each do |i|
  mh.add i
  puts "after add, mh is #{mh}\n\n"
end
