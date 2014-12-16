require 'hipku'
describe Hipku do
  context '.encode' do
    it 'correctly encodes an IPv4 address' do
      expect(described_class.encode('127.0.0.1')).to eq("The hungry white ape\naches in the ancient canyon.\nAutumn colors crunch.\n")
    end

    it 'correctly encodes a fully qualified IPv6 address' do
      expect(described_class.encode('da13:13a8:4776:d331:b07d:c53f:6714:d193')).to eq("Strong boats and brash quail\ndent lush steep dead shaped mint skunks.\nFar goats boot stary moths.\n")
    end

    it 'correctly encodes an IPv6 address with padding' do
      expect(described_class.encode('::1')).to eq("Ace ants and ace ants\naid ace ace ace ace ace ants.\nAce ants aid ace apes.\n")
    end

    it 'correctly encodes an IPv6 address with padding' do
      expect(described_class.encode('2c8f:27aa:61fd:56ec')).to eq("Cursed mobs and crazed queens\nfeel wrong gruff tired ace ace ants.\nAce ants aid ace ants.\n")
    end
  end

  context '.decode' do
    it 'correctly decodes an IPv4 address' do
      expect(described_class.decode("The hungry white ape\naches in the ancient canyon.\nAutumn colors crunch.\n")).to eq('127.0.0.1')
    end

    it 'correctly decodes an IPv4 address with weird spacing' do
      expect(described_class.decode("The hungry white    ape\n   aches in the      ancient canyon.    \n    Autumn    colors     crunch.\n")).to eq('127.0.0.1')
    end

    it 'correctly decodes an IPv6 address' do
      expect(described_class.decode("Strong boats and brash quail\ndent lush steep dead shaped mint skunks.\nFar goats boot stary moths.\n")).to eq('da13:13a8:4776:d331:b07d:c53f:6714:d193')
    end

    it 'correctly decodes an IPv6 address with words in two dictionaries' do
      expect(described_class.decode("Moist wraiths and mad guards\ndrown grey nude chilled black masked tools.\nShaped frogs blame drab ruffs.")).to eq('7efd:776c:5754:8420:0879:e9b0:5e0c:37b4')
    end

    it 'correctly decodes an IPv6 address with weird spacing' do
      expect(described_class.decode("Strong boats    and brash quail   \ndent lush     steep dead shaped mint skunks.\n     Far goats boot stary   moths.\n")).to eq('da13:13a8:4776:d331:b07d:c53f:6714:d193')
    end

    it 'correctly decodes an IPv6 address with front padding' do
      expect(described_class.decode("Ace ants and ace ants\naid ace ace ace ace ace ants.\nAce ants aid ace apes.\n")).to eq('0000:0000:0000:0000:0000:0000:0000:0001')
    end

    it 'correctly decodes an IPv6 address with back padding' do
      expect(described_class.decode("Cursed mobs and crazed queens\nfeel wrong gruff tired ace ace ants.\nAce ants aid ace ants.\n")).to eq('2c8f:27aa:61fd:56ec:0000:0000:0000:0000')
    end
  end
end
