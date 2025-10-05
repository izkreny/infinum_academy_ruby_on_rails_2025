RSpec.describe Color, :color do
  describe '#luminosity' do
    it 'returns correct value for a triple of integer values' do
      expect(described_class.new(23, 18, 191).luminosity).to eq(0.41)
    end

    it 'returns 1 for white' do
      expect(described_class.new(255, 255, 255).luminosity).to eq(1)
    end

    it 'returns 0 for black' do
      expect(described_class.new(0, 0, 0).luminosity).to eq(0)
    end
  end

  describe '#saturation' do
    it 'returns correct value for a triple of integer values' do
      expect(described_class.new(23, 18, 191).saturation).to eq(0.827)
    end

    it 'returns 0 for white' do
      expect(described_class.new(255, 255, 255).saturation).to eq(0)
    end

    it 'returns 0 for black' do
      expect(described_class.new(0, 0, 0).saturation).to eq(0)
    end
  end

  describe '#to_s' do
    it 'returns info for color' do
      expect(described_class.new(23, 18, 191).to_s).to eq('#1712BF: RGB(23, 18, 191); L: 0.41, S: 0.827')
    end

    it 'returns info for black color' do
      expect(described_class.new(0, 0, 0).to_s).to eq('#000000: RGB(0, 0, 0); L: 0.0, S: 0')
    end
  end

  describe 'sorting' do
    it 'returns most saturated and darker colors first, followed by washed out, light colors' do
      crimson = described_class.new(220, 20, 60)
      red = described_class.new(255, 0, 0)
      firebrick = described_class.new(178, 34, 34)
      rojo = described_class.new(230, 0, 38)
      white = described_class.new(255, 255, 255)
      light_red = described_class.new(255, 127, 127)
      black = described_class.new(0, 0, 0)

      colors = [crimson, red, firebrick, white, light_red, black, rojo]

      expect(colors.sort).to eq([rojo, red, light_red, crimson, firebrick, black, white])
    end
  end
end
