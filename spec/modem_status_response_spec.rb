require 'spec_helper'

module XBeeRuby
  RSpec.describe ModemStatusResponse do
    subject { ModemStatusResponse.new [0x8a, 0x12] }

    its(:modem_status) { is_expected.to eq 0x12 }

    describe 'can be reconstructed from a packet' do
      it { is_expected.to eq(Response.from_packet(Packet.new [0x8a, 0x12])) }
    end
  end
end
