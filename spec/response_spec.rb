require 'spec_helper'

module XBeeRuby
  RSpec.describe Response do
    describe '#new' do
      context 'with a packet type that is not implemented' do
        it 'raises an error' do
          expect { Response.from_packet(Packet.new [0x00, 0x1, 0x02, 0x03]) }.to raise_error(IOError)
        end
      end
    end
  end
end
