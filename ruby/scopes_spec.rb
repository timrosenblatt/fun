RSpec.describe 'Scopes' do
  describe 'of a function' do
    specify 'do not have access to outside local variables' do
      dog = :lassie

      def tester
        expect(defined? dog).to be_nil
      end

      tester()
    end

    specify 'do have access to outside instance variables' do
      @dog = :lassie

      def tester
        expect(@dog).to eq :lassie
      end

      tester
    end
  end

  context 'of a block' do
    it 'overwrites variables declared outside' do
      dog = 'lassie'

      [1].each do |number|
        dog = number
        word = 'woof'
      end

      expect(dog).to eq 1
    end

    it 'does not leak variables out' do
      [1].each do |number|
        word = 'woof'
      end

      expect(defined? word).to be_nil
    end

    it 'has access to variables declared outside' do
      word = 'woof'

      [1].each do |number|
        expect(word).to eq 'woof'
      end
    end

    it 'can define block-local variables' do
      dog = 'lassie'
      cat = 'garfield'
      fish = 'skippy'

      [1].each do |number; dog, cat|
        dog = 'fido'
        cat = 'oscar'
        fish = 'blurp'
      end

      expect(dog).to eq 'lassie'
      expect(cat).to eq 'garfield'
      expect(fish).to eq 'blurp'
    end

    it 'resets scope between iterations' do
      collector = []

      2.times do
        i ||= 1
        collector << i
        i += 1
        collector << i
      end

      expect(collector).to eq [1, 2, 1, 2]
      expect(collector).to_not eq [1, 2, 2, 3]
    end

    it 'capture scope at definition, not invocation' do
      def runtest
        x = 1
        lambda { x }
      end

      x = 2
      result = runtest.call

      expect(result).to eq 1
    end

    it 'captures scope at defintion, through functions' do
      a = 1
      show_a = lambda { a = 2 }

      def try_it(block)
        a = 3
        block.call
        expect(a).to be 3
      end

      try_it(show_a)

      # since a is reference to the scope when defined, ruby declares
      # a new 'a' inside the function. Running the block causes the reference
      # to the 'a' that was captured when the block was defined. Modifying
      # which value 'a' points to by running the block modifies the 'a' that was
      # captured
      expect(a).to be 2
    end
  end

  describe 'of a class' do
    class Dog
      def initialize(value)
        @@speak = value
        @speak = value
      end

      def speak_class
        @@speak
      end

      def speak_instance
        @speak
      end
    end

    before do
      @d1 = Dog.new(:woof)
      @d2 = Dog.new(:bark)
    end

    it 'shares class variables' do
      expect(@d1.speak_class).to eq :bark
      expect(@d2.speak_class).to eq :bark
    end

    it 'does not share instance variables' do
      expect(@d1.speak_instance).to eq :woof
      expect(@d2.speak_instance).to eq :bark
    end
  end

end
