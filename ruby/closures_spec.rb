RSpec.describe 'Closures' do
  # lambdas are like methods, and can explicitly return values
  describe 'as a lambda' do
    it 'allows returning values' do
      result = lambda do
        return 'dog'
      end.call

      expect(result).to eq 'dog'
    end

    it 'allows using next to return' do
      result = lambda do
        :a
        next :b
        return :c
        :d
      end.call

      expect(result).to eq :b
    end
  end

  describe 'as a proc' do
    it 'does not allow returns' do
      p = Proc.new { return 'in proc' }

      expect { p.call }.to raise_error LocalJumpError, /unexpected return/
    end

    it 'does capture final value' do
      p = Proc.new { :a ; :b }

      expect(p.call).to eq :b
    end

    it 'does allow next to return a value' do
      p = Proc.new do
        next 'in proc'
        next 'not anymore'
        'not final value'
      end

      expect(p.call).to eq 'in proc'
    end
  end

  describe 'as a block' do
    it 'accepts a parameter' do
      def the_method
        yield('value')
      end

      the_method do |input|
        expect(input).to eq 'value'
      end
    end

    it 'must be provided if they are called with yield' do
      def the_method
        yield
      end

      expect { the_method }.to raise_error LocalJumpError, /no block given/
    end

    it 'can be tested for' do
      def the_method
        yield if block_given?
      end

      expect { the_method }.to_not raise_error
    end

    it 'can be captured in a variable' do
      # This seems like what Proc.new does under the hood -- probably just
      # captures the block and returns it
      def the_method(&the_block)
        the_helper(the_block)
      end

      def the_helper(my_block)
        my_block.call
      end

      result = the_method do
        'yes'
      end

      expect(result).to eq 'yes'
    end
  end
end
