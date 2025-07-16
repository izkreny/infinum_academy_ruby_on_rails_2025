RSpec.describe OpenWeatherMap::City do
  context 'when a new City object is created' do
    city = described_class.new(
      id: 2_152_667,
      lat: -38.3333,
      lon: 141.6,
      name: 'Portland',
      temp_k: 285.58
    )

    it 'correctly initialise all instance variables' do
      expect(city.id).to   eq 2_152_667
      expect(city.lat).to  eq(-38.3333)
      expect(city.lon).to  eq 141.6
      expect(city.name).to eq 'Portland'
    end

    it 'correctly converts temperature from Kelvin to Celsius' do
      expect(city.temp).to eq 12.43
    end
  end

  context 'when we have two City objects' do
    it 'compares them correctly if a receiver has a lower temperature than the other object' do
      receiver = described_class.new(
        id: 2_759_794, lat: 52.374, lon: 4.8897,
        name: 'Amsterdam', temp_k: 292.28
      )
      other = described_class.new(
        id: 2_152_667, lat: -38.3333, lon: 141.6,
        name: 'Portland', temp_k: 292.29
      )
      expect(receiver > other).to be false
    end

    it 'compares them correctly if a receiver has a higher temperature than the other object' do
      receiver = described_class.new(
        id: 2_759_794, lat: 52.374, lon: 4.8897,
        name: 'Amsterdam', temp_k: 292.29
      )
      other = described_class.new(
        id: 2_152_667, lat: -38.3333, lon: 141.6,
        name: 'Portland', temp_k: 292.28
      )
      expect(receiver > other).to be true
    end

    it 'compares them correctly if a receiver has the same temperature as the other object,' \
       'but the receiver name comes first alphabetically' do
      receiver = described_class.new(
        id: 2_759_794, lat: 52.374, lon: 4.8897,
        name: 'Amsterdam', temp_k: 292.29
      )
      other = described_class.new(
        id: 2_152_667, lat: -38.3333, lon: 141.6,
        name: 'Portland', temp_k: 292.29
      )
      expect(receiver > other).to be false
    end

    it 'compares them correctly if a receiver has the same temperature as the other object, ' \
       'but the receiver name comes second alphabetically' do
      receiver = described_class.new(
        id: 2_152_667, lat: -38.3333, lon: 141.6,
        name: 'Portland', temp_k: 292.29
      )
      other = described_class.new(
        id: 2_759_794, lat: 52.374, lon: 4.8897,
        name: 'Amsterdam', temp_k: 292.29
      )
      expect(receiver > other).to be true
    end

    it 'compares them correctly if a receiver has the same temperature and name ' \
       'as the other object' do
      receiver = described_class.new(
        id: 2_759_794, lat: 52.374, lon: 4.8897,
        name: 'Amsterdam', temp_k: 292.29
      )
      other = described_class.new(
        id: 2_759_794, lat: 52.374, lon: 4.8897,
        name: 'Amsterdam', temp_k: 292.29
      )
      expect(receiver == other).to be true
    end
  end
end
