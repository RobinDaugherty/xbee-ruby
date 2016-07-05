require 'spec_helper'

module XBeeRuby
  RSpec.describe TxResponse do
    subject { TxResponse.new [0x8b, 0x1, 0xab, 0xcd, 0x02, 0x03, 0x04] }

    its(:frame_id) { is_expected.to eq 0x01 }
    its(:address16) { is_expected.to eq Address16.new(0xab, 0xcd) }
    its(:retry_count) { is_expected.to eq 0x02 }
    its(:delivery_status) { is_expected.to eq 0x03 }
    its(:discovery_status) { is_expected.to eq 0x04 }

    describe 'can be reconstructed from a packet' do
      it { is_expected.to eq(Response.from_packet(Packet.new [0x8b, 0x1, 0xab, 0xcd, 0x02, 0x03, 0x04])) }
    end
  end
end
