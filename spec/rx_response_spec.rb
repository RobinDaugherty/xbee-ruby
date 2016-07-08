require 'spec_helper'

module XBeeRuby
  RSpec.describe RxResponse do
    subject(:response) { described_class.new received_bytes }
    let(:received_bytes) { [0x90, 0x11, 0x22, 0x33, 0x44, 0x55, 0x66, 0x77, 0x88, 0xaa, 0xbb, 0x01, 0x12, 0x34] }

    describe '#new' do
      it 'parses the correct address64' do
        expect(response.address64).to eq Address64.new(0x11, 0x22, 0x33, 0x44, 0x55, 0x66, 0x77, 0x88)
      end
      it 'parses the correct address16' do
        expect(response.address16).to eq Address16.new(0xaa, 0xbb)
      end
      it 'parses the correct receive_options' do
        expect(response.receive_options).to eq 0x01
      end
      it 'parses the correct data' do
        expect(response.data).to eq [0x12, 0x34]
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
        let(:other_response) { described_class.new([0x90, 0x22, 0x33, 0x44, 0x55, 0x66, 0x77, 0x88, 0xaa, 0xbb, 0x01, 0x12, 0x34]) }
        it 'does not find equality' do
          expect(subject == other_response).to be_falsey
        end
      end
    end

    it 'is constructed from a packet with the correct contents' do
      constructed_response = Response.from_packet(Packet.new [0x90, 0x11, 0x22, 0x33, 0x44, 0x55, 0x66, 0x77, 0x88, 0xaa, 0xbb, 0x01, 0x12, 0x34])
      expect(constructed_response).to eq(response)
      expect(constructed_response).to be_a(described_class)
    end
  end
end
