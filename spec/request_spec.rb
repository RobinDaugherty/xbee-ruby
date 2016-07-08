require 'spec_helper'

module XBeeRuby
  RSpec.describe Request do
    subject(:request) { described_class.new }

    describe '#frame_id' do
      subject(:frame_id) { request.frame_id }
      it 'is different for each new instance' do
        expect(frame_id).to_not eq(Request.new.frame_id)
      end
    end

    describe '#frame_data' do
      it 'raises an exception because Request is abstract' do
        expect { request.frame_data }.to raise_error(StandardError, /Override/)
      end
    end

    describe '#packet' do
      subject(:packet) { request.packet }
      before do
        allow(Request).to receive(:next_frame_id).and_return 1
        expect(request).to receive(:frame_data).and_return [0x12, 0x34, 0x56]
        expect(request).to receive(:frame_type).and_return 0xaa
      end
      it 'instantiates a Packet object with the correct data' do
        expect(packet).to eq Packet.new([0xaa, 0x01, 0x12, 0x34, 0x56])
      end
    end
  end
end
