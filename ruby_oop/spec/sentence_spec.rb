RSpec.describe Sentence, :sentence do
  it 'mangles input' do
    expect(shatro('rodio se u maloj kuci')).to eq('dioro se u lojma ciku')
    expect(shatro('nemoj ga ni nista pitat')).to eq('mojne ga ni stani tatpi')
    expect(shatro('gatsby hlace i krunicu')).to eq('tsbyga cehla i nicukru')
    expect(shatro('gramofona ima sedam')).to eq('mofonagra mai damse')
    expect(shatro('niko nista da ne zucne')).to eq('koni stani da ne cnezu')
    expect(shatro('ab')).to eq('ab')
  end

  it 'returns a Sentence' do
    expect(described_class.new('recenica')).to be_a(described_class)
  end

  it 'sentence objects holds reference to words' do
    expect(described_class.new('dvije recenice').words).to all(be_a(Word))
  end

  it 'words can call #to_shatro' do
    expect(described_class.new('dvije recenice').words).to all(respond_to(:to_shatro))
  end

  it 'word object holds reference to characters' do
    characters = described_class.new('primjer').words.first.characters

    expect(characters).to all(be_a(Character))
  end

  it 'character knows if its a vowel' do
    characters = described_class.new('primjer').words.first.characters

    expect(characters.map(&:vowel?)).to eq([false, false, true, false, false, true, false])
  end

  def shatro(input)
    described_class.new(input).to_shatro
  end
end
