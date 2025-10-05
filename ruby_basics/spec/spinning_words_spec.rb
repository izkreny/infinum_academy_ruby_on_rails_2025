RSpec.describe 'spinning_words', :spinning_words do
  it 'mangles input' do
    expect(spinning_words('rodio se u maloj kuci')).to eq('oidor se u jolam kuci')
    expect(spinning_words('nemoj ga ni nista pitat')).to eq('jomen ga ni atsin tatip')
    expect(spinning_words('gatsby hlace i krunicu')).to eq('ybstag ecalh i ucinurk')
    expect(spinning_words('gramofona ima sedam')).to eq('anofomarg ima mades')
    expect(spinning_words('niko nista da ne zucne')).to eq('niko atsin da ne encuz')
    expect(spinning_words('ababa')).to eq('ababa')
    expect(spinning_words('rijec')).to eq('cejir')
    expect(spinning_words('ab')).to eq('ab')
    expect(spinning_words('')).to eq('')
  end
end
