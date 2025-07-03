RSpec.describe 'class_objects', :class_objects do
  it 'transforms empty array to empty hash' do
    expect(class_objects([])).to eq({})
  end

  context 'when String, Integer, NilClass and boolean elements' do
    it 'transforms array to hash' do
      expect(class_objects(['ruby', 1, true, 3])).to eq(
        { String => ['ruby'], Integer => [1, 3], TrueClass => [true] }
      )
      expect(class_objects([42, nil, false, false])).to eq(
        { Integer => [42], NilClass => [nil], FalseClass => [false, false] }
      )
    end
  end

  context 'when elements are Arrays and Hashes' do
    it 'transforms array to hash' do
      expect(class_objects([[], {}, [], {}])).to eq(
        { Array => [[], []], Hash => [{}, {}] }
      )
      expect(class_objects([[1, 2, 3], nil, :a, :b, { a: 1 }, [:a, :b]])).to eq(
        {
          Array => [[1, 2, 3], [:a, :b]], NilClass => [nil], Symbol => [:a, :b],
          Hash => [{ a: 1 }]
        }
      )
    end
  end
end
