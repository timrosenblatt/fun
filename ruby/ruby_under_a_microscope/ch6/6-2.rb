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
  # search doesn't go through the modules.
end
