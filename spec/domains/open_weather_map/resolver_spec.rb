RSpec.describe OpenWeatherMap::Resolver do
  context 'when #city_id is called with a known city name' do
    it 'returns the correct id' do
      expect(described_class.city_id('Rijeka')).to eq 3_191_648
    end
  end

  context 'when #city_id is called with a unknown city name' do
    it 'returns nil' do
      expect(described_class.city_id('Nigdjezemska')).to be_nil
    end
  end
end
