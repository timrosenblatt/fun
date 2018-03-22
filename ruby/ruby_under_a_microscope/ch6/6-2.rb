class Person
end

module Drummer
end

module Snowboarder
end

module Engineer
end


class Bob < Person
  puts "When we start, the inheritance chain is Bob, Person, Object..."
  puts ancestors.join ', '

  include Drummer
  puts "\n\n"
  puts "After including Drummer, the inheritance chain is now Bob, *Drummer*, Person, Object..."
  puts ancestors.join ', '

  include Snowboarder
  puts "\n\n"
  puts "Now that we've included a second module, the inheritance chain is Bob, *Snowboarder*, Drummer, Person, Object..."
  puts ancestors.join ', '

  include Engineer
  puts "\n\n"
  puts "Finally after a third module, the inheritance chain is Bob, Engineer, Snowboarder, Drummer, Person, Object..."
  puts ancestors.join ', '

  # What this teaches is that including a module doesn't add the methods to
  # the class that you're including the module into. The linked list that
  # represents the class hierarchy inserts a reference to the module above
  # the self. This is possible because inside Ruby, modules are actually classes,
  # so the superclass pointer can point to them.

  puts "\n\n"
  puts "The weird thing is that superclass isn't the module. It's Person"
  puts superclass

  # Even though ancestors is clearly being changed, something about the superclass
  # search doesn't count modules.
end

puts "\n\n"

# Internally, when you include a module, Ruby creates a copy of the module structore
# to put into the superclass inheritance chain

class Alice
  include Engineer
end

# This is false
puts Alice.new.respond_to?(:write_code)

module Engineer
  def write_code
  end
end

# This is true
puts Alice.new.respond_to?(:write_code)

# When Ruby makes a copy of the module class, it's method table pointer (m_tbl)
# still points to the same method table in memory, which is why when we reopen
# the method module and define a new method, Alice still gets it even though
# technically the inheritance chain is pointing at a copy of the module's class.
# They just have to make a copy of it because it's a node in a linked list and
# they need to be able to change where the superclass pointers go. There's no
# benefit in duplicating the method table each time.

# Apparently "extend" works the same way as this, except instead of the class's
# superclass linked list changing, the metaclass's superclass pointer is changed.
