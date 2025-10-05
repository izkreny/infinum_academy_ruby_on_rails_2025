RSpec.describe 'all_letters', :all_letters do
  it 'returns true when all letters used' do
    expect(all_letters?('abcdefghijklmnopqrstuvwxyz')).to eq(true)
    expect(all_letters?('ABCDEFGHIJKLMNOPQRSTUVWXYZ')).to eq(true)
    expect(all_letters?('AbCdEfGhIjKlMnOpQrStUvWxYz')).to eq(true)
    expect(
      all_letters?('The quick brown fox jumps over the lazy dog')
    ).to eq(true)
    expect(
      all_letters?("A wizard's job is to vex chumps quickly in fog.")
    ).to eq(true)
  end

  it 'returns false when not all letters used' do
    expect(all_letters?('')).to eq(false)
    expect(all_letters?('123456789')).to eq(false)
    expect(all_letters?('abcdefghijklmnopqrstuvwxy')).to eq(false) # missing z
    expect(all_letters?('Here are some letters missing')).to eq(false)
  end
end
