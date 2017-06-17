# The problem with classes as namespaces is with the way that constant lookup works

if String::Hash == Hash
  puts "That's not right!"
end

# This is obviously not real. String does not contain a nested class Hash
# You even see Ruby issue `warning: toplevel constant...`

# This happens because when we reference String::Hash, Ruby looks at
# String.constants to find Hash.

# irb(main):019:0> String.constants
# => []

# It doesn't exist. Then Ruby looks up the ancestor chain

# irb(main):012:0> String.ancestors
# => [String, Comparable, Object, Kernel, BasicObject]

# So Ruby looks at Comparable

# irb(main):016:0> Comparable.constants
# => []

# Nope. Next ancestor is Object

# irb(main):001:0> Object.constants
# => [:Object, :Module, :Class, :BasicObject, ..., :Array, :Hash, ...]

# OK now we are onto something. Ruby sees Hash in there, so it uses it
# as the constant it thinks we are looking for.

# This leads to bugs. If we have a reference to a nested class Eat,
# but it hasn't been defined AND there is a global constant Eat that does
# exist, we now have a bug because the code we're writing doesn't
# call the code we want.

class Eat
  def self.yum
    'mmm good'
  end
end

class Dog
end

if Dog::Eat.yum == 'mmm good'
  puts 'Oh no'
end

# Imagine that our load sequence goes funny, and although we did define
# a Dog::Eat, it wasn't loaded until later (kind of what could happen with)
# Rails autoloading
class Dog::Eat
  def self.yum
    'i did not eat that'
  end
end

# The thing is, modules don't do this. Modules don't have ancestors the way
# that classes do, so a missed constant will actually raise an error

class Meow
  def self.speak
    'mrow'
  end
end

module Cat
end


begin
  # Same pattern as before, with a missed reference,
  # except now Cat is a module instead of a class
  Cat::Meow.speak
rescue NameError
  # If we didn't rescue this, this code would crash, because unlike Dog.ancestors
  # Cat.ancestors is empty, so it doesn't fall back to looking at Object,
  # and even though Object.constants *does* contain Meow, it won't accidentally
  # get used.
end

# For another walkthrough of this issue
# https://blog.jetbrains.com/ruby/2017/03/why-you-should-not-use-a-class-as-a-namespace-in-rails-applications/

# Also the Ruby team is looking at changing the way constant lookup works. 
# https://bugs.ruby-lang.org/issues/11547
