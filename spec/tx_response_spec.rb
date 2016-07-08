require 'spec_helper'

module XBeeRuby
  RSpec.describe TxResponse do
    subject(:response) { TxResponse.new [0x8b, 0x1, 0xab, 0xcd, 0x02, 0x03, 0x04] }

    describe '#new' do
      it 'parses the correct frame_id' do
        expect(response.frame_id).to eq 0x01
      end
      it 'parses the correct address16' do
        expect(response.address16).to eq Address16.new(0xab, 0xcd)
      end
      it 'parses the correct retry_count' do
        expect(response.retry_count).to eq 0x02
      end
      it 'parses the correct delivery_status' do
        expect(response.delivery_status).to eq 0x03
      end
      it 'parses the correct discovery_status' do
        expect(response.discovery_status).to eq 0x04
      end
    end

    it 'is constructed from a packet with the correct contents' do
      constructed_response = Response.from_packet(Packet.new [0x8b, 0x1, 0xab, 0xcd, 0x02, 0x03, 0x04])
      expect(constructed_response).to eq(response)
      expect(constructed_response).to be_a(described_class)
    end
  end
end
