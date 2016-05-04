#!/usr/bin/env ruby -w

# puts "make a max heap that works in an array\n\n"

class MaxHeap

  # Helpful for debugging
  # Not super happy with the exact layout right now,
  # it has a bias towards the right, but it is
  # at least good enough to visualize the heap
  def render_tree
    how_many = 0
    pointer = 0
    depth = 0

    height = height_of_index(@heap.length - 1) + 1
    while children_exist(depth) do
      how_many = 2 ** depth
      width = height - depth + 1
      # current_value_width = (((2 ** (width)) / width) * 3)
      current_value_width = (2 ** width) + 1
      # puts "#{width}, #{current_value_width}"

      (0..how_many-1).each do |i|
        location = pointer + i
        # puts "checking location #{location}"
        break unless exists?(location)
        # puts "%#{width}d" % value(location).to_s
        # current_value_width = (2 * (width + value(location).to_s.length)) + (i % 2)

        # current_value_width = 2 * (how_many)

        printf("%#{current_value_width}d", value(location))
      end

      puts "\n"

      pointer += how_many
      depth += 1
    end

    puts "\n"
  end

  def children_exist(depth)
    exists?((2 ** depth) - 1)
  end

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

  def delete
    deleted_value = @heap[0]
    # Step 1 − Remove root node.
    # Step 2 − Move the last element of last level to root.
    tail_value = @heap.pop

    return deleted_value if @heap.empty?

    @heap[0] = tail_value

    # render_tree

    parent_index = 0

    while(child_exists?(parent_index)) do
      # puts "looping at parent index #{parent_index}"
      if !swap_needed?(parent_index)
        break
      else
        if right_child_exists?(parent_index) && right_child_value(parent_index) > left_child_value(parent_index)
          # puts 'swapping to right'
          # puts "swapping #{value(parent_index)}, #{right_child_value(parent_index)}"
          swap(parent_index, right_child_index(parent_index))
          next_parent_index = right_child_index(parent_index)
        else
          # puts 'swapping to left'
          # puts "swapping #{value(parent_index)}, #{left_child_value(parent_index)}"
          swap(parent_index, left_child_index(parent_index))
          next_parent_index = left_child_index(parent_index)
        end
      end

      # break unless child_exists?(next_parent_index)
      parent_index = next_parent_index
    end

    deleted_value
  end

  private

  def exists?(index)
    !@heap[index].nil?
  end

  def swap_needed?(parent_index)
    ( left_child_exists?(parent_index) && left_child_needs_to_be_swapped?(parent_index) ) ||
      ( right_child_exists?(parent_index) && right_child_needs_to_be_swapped?(parent_index) )
  end

  def left_child_needs_to_be_swapped?(parent_index)
    left_child_value(parent_index) > value(parent_index)
  end

  def right_child_needs_to_be_swapped?(parent_index)
    right_child_value(parent_index) > value(parent_index)
  end


  def value(index)
    @heap[index]
  end

  def child_exists?(index)
    left_child_exists?(index) || right_child_exists?(index)
  end

  def left_child_value(parent_index)
    lci = left_child_index(parent_index)
    value lci
  end

  def right_child_value(parent_index)
    rci = right_child_index(parent_index)
    value rci
  end

  def left_child_index(index)
    # puts index
    2 * index + 1
  end

  def right_child_index(index)
    2 * index + 2
  end

  def left_child_exists?(index)
    lci = left_child_index(index)
    # puts "lci #{lci}"
    !value(lci).nil?
  end

  def right_child_exists?(index)
    !value(right_child_index(index)).nil?
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

(0..20).each do |i|
  mh.add i
  # puts "after add, mh is #{mh}\n\n"
end

# puts mh.render_tree
puts mh.delete
# puts mh.render_tree
puts mh.delete
# puts mh.render_tree
puts mh.delete
# puts mh.render_tree
puts mh.delete
# puts mh.render_tree
puts mh.delete
# puts mh.render_tree
puts mh.delete
# puts mh.render_tree
puts mh.delete
# puts mh.render_tree
puts mh.delete
# puts mh.render_tree
puts mh.delete
# puts mh.render_tree
puts mh.delete
# puts mh.render_tree
puts mh.delete
# puts mh.render_tree
puts mh.delete
puts mh.delete
puts mh.delete
puts mh.delete
puts mh.delete
puts mh.delete
puts mh.delete
puts mh.delete
puts mh.delete
puts mh.delete
