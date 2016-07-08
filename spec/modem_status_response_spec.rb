require 'spec_helper'

module XBeeRuby
  RSpec.describe ModemStatusResponse do
    subject(:response) { ModemStatusResponse.new received_bytes }
    let(:received_bytes) { [0x8a, 0x12] }

    describe '#modem_status' do
      it 'is the correct value from the packet' do
        expect(response.modem_status).to eq(0x12)
      end
    end

    describe '#==' do
      context 'when the other response has the same value' do
        let(:other_response) { described_class.new(received_bytes) }
        it 'finds equality' do
          expect(subject == other_response).to be_truthy
        end
      end
      context 'when the other response is different' do
        let(:other_response) { described_class.new([0x8a, 0x13]) }
        it 'does not find equality' do
          expect(subject == other_response).to be_falsey
        end
      end
    end

    it 'is constructed from a packet with the correct contents' do
      constructed_response = Response.from_packet(Packet.new([0x8a, 0x12]))
      expect(constructed_response).to eq(response)
      expect(constructed_response).to be_a(described_class)
    end
  end
end
