# This is Ruby 2.2 functionality
# http://www.schneems.com/2015/01/14/debugging-super-methods-ruby-22.html

class Dog
  def bark
    puts "woof"
  end
end

describe 'Using source_location' do
  subject { Dog.new.method(:bark).source_location }

  it 'returns an Array' do
    expect(subject.class).to eq Array
  end

  it 'knows the file' do
    expect(subject[0]).to eq __FILE__
  end

  it 'knows the line of the definition' do
    expect(subject[1]).to eq 5
  end
end

class SchneemsDog < Dog
  def bark
    super
  end
end

describe 'how source_location works with inheritance' do
  let(:cinco) { SchneemsDog.new }
  let(:schneem_location) { cinco.method(:bark).source_location[1] }
  let(:super_location) { cinco.class.superclass.instance_method(:bark).source_location[1] }

  it 'returns the location of the immediate method' do
    expect(schneem_location).to eq 27
  end

  it 'returns the location of super' do
    expect(super_location).to eq 5
  end
end

# Up until this point, everything is fine. But, once
# we start doing some metaprogramming...

module DoubleBark
  def bark
    super
    super
  end
end

describe 'how source_location can get misled' do
  let(:cinco) { SchneemsDog.new }
  let(:actual_method_call) { cinco.method(:bark).to_s }
  let(:method_definition_location) { cinco.class.superclass.instance_method(:bark).to_s }

  before do
    cinco.extend(DoubleBark)
  end

  it 'calls the right method' do
    expect(actual_method_call).to include 'SchneemsDog(DoubleBark)#bark'
  end

  it 'does not find the method using super' do
    # This should return the module, not Dog.
    # The result expected here represents the bug. The return value should
    # reference the DoubleBark module, since that's the code that's executing
    expect(method_definition_location).to include 'UnboundMethod: Dog#bark'
  end
end

# So, now that we've seen the bug, here's Schneeman's 
