
# Imagine we have an image where every pixel is white or black.
# We'll represent this image as a simple 2D array (0 = black, 1 = white).
# The image you get is known to have a single black rectangle on a
# white background.  Your goal is to find this rectangle and
# return its coordinates.


image = [
  [1, 1, 1, 1, 1, 1, 1],
  [1, 1, 1, 1, 1, 1, 1],
  [1, 1, 1, 0, 0, 0, 1],
  [1, 1, 1, 0, 0, 0, 1],
  [1, 1, 1, 1, 1, 1, 1]
]

image_right_edge = [
  [1, 1, 1, 1, 1, 1, 1],
  [1, 1, 1, 1, 1, 1, 1],
  [1, 1, 1, 0, 0, 0, 0],
  [1, 1, 1, 0, 0, 0, 0],
  [1, 1, 1, 1, 1, 1, 1]
]

image_bottom_edge = [
  [1, 1, 1, 1, 1, 1, 1],
  [1, 1, 1, 1, 1, 1, 1],
  [1, 1, 1, 0, 0, 0, 1],
  [1, 1, 1, 0, 0, 0, 1],
  [1, 1, 1, 0, 0, 0, 1]
]

image_one_zero = [
  [1, 1, 1, 1, 1, 1, 1],
  [1, 1, 1, 1, 1, 1, 1],
  [1, 1, 1, 1, 1, 1, 1],
  [1, 1, 1, 1, 1, 1, 1],
  [1, 1, 1, 1, 1, 1, 0]
]


# top: 2, left: 3


def bottom_boundary(input, top, left)
  zero_position = nil

  puts "bottom_boundary top: #{top} left: #{left}"

  (top..input.length - 1).each do |i|
    puts "loop, i=#{i}"
    if input[i][left] == 0
      zero_position = i
    else
      return zero_position
    end
  end

  zero_position
end



def right_boundary(input, top, left)
  row = input[top]
  zero_position = nil

  (left..row.length - 1).each do |i|
    if row[i] == 0
      zero_position = i
    else
      return zero_position
    end
  end

  zero_position
end

def solution(input)
  top, left = find_top_left(input)

  right = right_boundary(input, top, left)

  bottom = bottom_boundary(input, top, left)

  return { top: top, left: left, bottom: bottom, right: right }
end

def find_top_left(input)
  input.each_with_index do |r_val, row_index|
    r_val.each_with_index  do |c_val, column_index|
      if input[row_index][column_index] == 1
        next
      else
        return [row_index, column_index]
      end
    end
  end
end


# Now there are N solid black rectangles in the image.  Find them all.

multiple = [
  [1, 1, 1, 1, 1, 1, 1],
  [1, 1, 1, 1, 1, 1, 1],
  [1, 1, 1, 0, 0, 0, 1],
  [1, 0, 1, 0, 0, 0, 1],
  [1, 0, 1, 1, 1, 1, 1],
  [1, 0, 1, 0, 0, 1, 1],
  [1, 1, 1, 0, 0, 1, 1],
  [1, 1, 1, 1, 1, 1, 1],
]

yes_rectangle = [
  [1, 1, 1, 1, 1, 1, 1],
  [1, 1, 1, 1, 1, 1, 1],
  [1, 1, 1, 1, 1, 1, 1],
  [1, 1, 1, 1, 1, 1, 1],
  [1, 1, 1, 1, 1, 1, 0]
]

no_rectangle = [
  [1, 1, 1, 1, 1, 1, 1],
  [1, 1, 1, 1, 1, 1, 1],
  [1, 1, 1, 1, 1, 1, 1],
  [1, 1, 1, 1, 1, 1, 1],
  [1, 1, 1, 1, 1, 1, 1]
]

def any_rectangles?(input)
  input.each do |row|
    return true if row.include?(0)
  end

  false
end


def fill_rectangle(input, c)
  (c[:left]..c[:right]).each do |col|
    (c[:top]..c[:bottom]).each do |row|
      input[row][col] = 1
    end
  end

  input
end

# There are some optimizations to this whole thing. The biggest one is
# that I'm searching the same space over and over. Since this algorithm
# is more or less top-left, it means that any time a rectangle is found
# the area to the top and left of the top-left corner doesn't need to be
# searched again. Overall it's O(width * height) and that's done repeatedly.
# It's definitely possible to either do sub-calls with logical boundaries
# or literally slice it into sub-rectangles (ie: new objects).
# And, in a map-reduce-y solution, the whole problem can be broken apart
# into sub-problems that can be calculated independently, and then re-composed.
def find_all(input)
  solutions = []

  while any_rectangles?(input) do
    solution = solution(input)

    solutions << solution

    fill_rectangle input, solution
  end

  solutions
end
