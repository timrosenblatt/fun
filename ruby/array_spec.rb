# Based off 2.2.0
# http://ruby-doc.org/core-2.2.0/Array.html
RSpec.describe Array do
  it 'creates multidimensional arrays' do
    a = Array.new(3) { Array.new(4,0) }

    expect(a[0]).to eq [0,0,0,0]
    expect(a[1]).to eq [0,0,0,0]
    expect(a[2]).to eq [0,0,0,0]
  end

  context 'accessing elements' do
    let(:a) { [0, 1, 2] }

    it 'returns nil for invalid indices using bracket syntax' do
      expect(a[3]).to be_nil
    end

    it 'raises an error for invalid indices using fetch' do
      expect{a.fetch(3)}.to raise_error(IndexError)
    end
  end

  context 'working with batches' do
    let(:a) { [0, 1, 2, 3, 4, 5] }
    it 'taking elements from front of array' do
      expect(a.take 2).to eq [0, 1]
    end

    it 'getting elements from end of array' do
      expect(a.drop 2).to eq [2, 3, 4, 5]
    end
  end

  context 'adding elements' do
    let(:a) { [0, 1] }

    it 'to the front' do
      a.unshift -1

      expect(a).to eq [-1, 0, 1]
    end

    it 'at arbitrary locations' do
      a.insert 1, 'dog'

      expect(a).to eq [0, 'dog', 1]
    end

    it 'at arbitrary locations in groups' do
      a.insert 1, 'dog', 'cat'

      expect(a).to eq [0, 'dog', 'cat', 1]
    end
  end

  context 'deleting elements' do
    let(:a) { [0, 1, 2, 3] }

    it 'from the end' do
      a.pop

      expect(a).to eq [0, 1, 2]
    end

    it 'from the front' do
      a.shift

      expect(a).to eq [1, 2, 3]
    end

    it 'from arbitary location' do
      a.delete(1)

      expect(a).to eq [0, 2, 3]
    end
  end

  it 'removes nil elements' do
    a = [1, 2, nil, 4, 5, nil, 7]

    a.compact!

    expect(a).to eq [1, 2, 4, 5, 7]
  end

  context 'class methods' do
    context '[]' do
      it 'can be used as Array.[]' do
        a = Array.[](:a, :b)

        expect(a).to be_a Array
        expect(a.length).to eq 2
      end

      it 'can be used as Array[]' do
        a = Array[:a, :b]

        expect(a).to be_a Array
        expect(a.length).to eq 2
      end

      it 'can be used as []' do
        a = [:a, :b]

        expect(a).to be_a Array
        expect(a.length).to eq 2
      end
    end

    context 'new' do
      context 'with size and default object' do
        it 'contains multiple copies of the exact same object' do
          o = Object.new
          a = Array.new(2, o)

          expect(a.length).to eq 2
          expect(a[0]).to be a[1]
        end

        it 'really is the same object' do
          h = {dog: :arf}
          a = Array.new(2, h)
          a[0][:dog] = :woof

          expect(a[1][:dog]).to be :woof
        end
      end

      context 'with an array as argument' do
        it 'creates a new array' do
          a = [1, 2]

          b = Array.new(a)

          expect(a).to eq b
          expect(a).to_not be b
        end
      end

      context 'with a size and block' do
        it 'sets each value to the return value of the block' do
          a = Array.new(3) do |index|
            index * 2
          end

          expect(a.length).to be 3
          expect(a[0]).to be 0
          expect(a[1]).to be 2
          expect(a[2]).to be 4
        end

        it 'creates each index with a different object' do
          a = Array.new(2) do |index|
            {}
          end
          a[0][:dog] = :woof

          expect(a[1]).to be {}
        end
      end
    end
  end
end
