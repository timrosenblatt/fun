class Person
end

module Drummer
  def drum
  end
end

module Snowboarder
  def jump
  end
end

module Engineer
  def code
  end
end

class Bob < Person
  include Drummer
  include Snowboarder
  include Engineer

  def name
  end
end

class Object
  # This is more or less how Ruby does method lookup internally
  def who_responds_to?(method, klass_ancestors = nil)
    if klass_ancestors.nil?
      return who_responds_to?(method, self.class.ancestors)
    end

    if klass_ancestors.empty?
      return nil
    end

    if klass_ancestors[0].instance_methods(false).include?(method)
      return klass_ancestors[0]
    end

    klass_ancestors.shift

    who_responds_to?(method, klass_ancestors)
  end
end

bob = Bob.new

puts "who responds to name"
puts bob.who_responds_to?(:name)
puts "\n"

puts "who responds to code"
puts bob.who_responds_to?(:code)
puts "\n"

puts "who responds to jump"
puts bob.who_responds_to?(:jump)
puts "\n"

puts "who responds to drum"
puts bob.who_responds_to?(:drum)
puts "\n"

puts "who responds to dance"
puts bob.who_responds_to?(:dance)
