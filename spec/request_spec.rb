require 'spec_helper'

module XBeeRuby
  RSpec.describe Request do
    its(:frame_id) { is_expected.to eq 1 }
    its(:frame_id) { is_expected.to_not eq Request.new.frame_id }

    describe '#frame_data' do
      it 'raises an exception because Request is abstract' do
        expect { subject.frame_data }.to raise_error
      end
    end

    describe '#packet' do
      before do
        allow(Request).to receive(:next_frame_id).and_return 1
        expect(subject).to receive(:frame_data).and_return [0x12, 0x34, 0x56]
        expect(subject).to receive(:frame_type).and_return 0xaa
      end
      its (:packet) { is_expected.to eq Packet.new([0xaa, 0x01, 0x12, 0x34, 0x56]) }
    end
  end
end
