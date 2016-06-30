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
end
