require 'hipku'
describe Hipku do
  it 'correctly encodes an IPv4 address' do
    expect(described_class.encode('127.0.0.1')).to eq("The hungry white ape\naches in the ancient canyon.\nAutumn colors crunch.\n")
  end

  it 'correctly encodes a fully qualified IPv6 address' do
    expect(described_class.encode('da13:13a8:4776:d331:b07d:c53f:6714:d193')).to eq("Strong boats and brash quail\ndent lush steep dead shaped mint skunks.\nFar goats boot stary moths.\n")
  end

  it 'correctly encodes a IPv6 address with padding' do
    expect(described_class.encode('::1')).to eq("Ace ants and ace ants\naid ace ace ace ace ace ants.\nAce ants aid ace apes.\n")
  end

  it 'correctly encodes a IPv6 address with padding' do
    expect(described_class.encode('2c8f:27aa:61fd:56ec')).to eq("Cursed mobs and crazed queens\nfeel wrong gruff tired ace ace ants.\nAce ants aid ace ants.\n")
  end
end
