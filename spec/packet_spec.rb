require 'spec_helper'

module XBeeRuby
  RSpec.describe Packet do
    subject(:packet) { Packet.new [0x7e, 0x12, 0x34, 0x56] }

    describe '#data' do
      subject { packet.data }
      it 'contains the data bytes of the packet' do
        expect(subject).to eq [0x7e, 0x12, 0x34, 0x56]
      end
    end

    describe '#length' do
      subject { packet.length }
      it 'returns the number of bytes in the data' do
        expect(subject).to eq 0x04
      end
    end

    describe '#checksum' do
      subject { packet.checksum }
      it 'calculates the checksum of the data' do
        expect(subject).to eq 0xe5
      end
    end

    describe '#bytes' do
      subject { packet.bytes }
      it 'contains all bytes including the frame and checksum' do
        expect(subject).to eq [0x7e, 0x00, 0x04, 0x7e, 0x12, 0x34, 0x56, 0xe5]
      end
    end

    describe '#bytes_escaped' do
      subject { packet.bytes_escaped }
      it 'returns all packet bytes for use with "API operation with escapes" mode' do
        expect(subject).to eq [0x7e, 0x00, 0x04, 0x7d, 0x5e, 0x12, 0x34, 0x56, 0xe5]
      end
    end

    describe '::special_byte?' do
      specify { expect(Packet.special_byte?(0x7e)).to be_truthy }
      specify { expect(Packet.special_byte?(0x7d)).to be_truthy }
      specify { expect(Packet.special_byte?(0x11)).to be_truthy }
      specify { expect(Packet.special_byte?(0x13)).to be_truthy }
      specify { expect(Packet.special_byte?(0x00)).to be_falsey }
    end

    describe '.unescape' do
      subject { described_class.unescape(escaped_bytes) }
      let(:escaped_bytes) { [0x00, 0x7d, 0x31, 0x22] }
      let(:original_bytes) { [0x00, 0x11, 0x22] }

      it 'correctly unescapes escaped bytes' do
        expect(subject).to eq(original_bytes)
      end

      context 'with a trailing escape character' do
        let(:escaped_byes) { [0x00, 0x11, 0x22, 0x7d] }
        it 'ignores the escape character' do
          expect(subject).to eq(original_bytes)
        end
      end
    end

    describe '.from_bytes' do
      subject(:packet) { Packet.from_bytes packet_bytes }

      context 'which form a valid frame' do
        let(:packet_bytes) { [0x7e, 0x00, 0x02, 0x11, 0x22, 0xcc] }
        it 'gets the correct data' do
          expect(packet.data).to eq [0x11, 0x22]
        end
      end

      context 'which form a valid frame with escaped bytes' do
        let(:packet_bytes) { [0x7e, 0x00, 0x02, 0x7d, 0x31, 0x22, 0xcc] }
        it 'gets the correct data' do
          expect(packet.data).to eq [0x11, 0x22]
        end
      end

      context 'with not enough bytes to form a valid frame' do
        let(:packet_bytes) { [0x7e, 0x00] }
        it 'raises an error' do
          expect { packet }.to raise_error(ArgumentError)
        end
      end

      context 'with a missing start byte' do
        let(:packet_bytes) { [0x00, 0x02, 0x7d, 0x31, 0x34, 0x46] }
        it 'raises an error' do
          expect { packet }.to raise_error(ArgumentError)
        end
      end

      context 'with an incorrect checksum' do
        let(:packet_bytes) { [0x7e, 0x00, 0x02, 0x7d, 0x31, 0x34, 0xaa] }
        it 'raises an error' do
          expect { packet }.to raise_error(ArgumentError)
        end
      end

      context 'with an incorrect length' do
        let(:packet_bytes) { [0x7e, 0x00, 0x88, 0x7d, 0x31, 0x34, 0xb9] }
        it 'raises an error' do
          expect { packet }.to raise_error(ArgumentError)
        end
      end
    end

    describe '.from_byte_enum' do
      subject(:packet) { Packet.from_byte_enum packet_bytes.to_enum }

      context 'which form a valid frame' do
        let(:packet_bytes) { [0x7e, 0x00, 0x02, 0x11, 0x22, 0xcc] }
        it 'gets the correct data' do
          expect(packet.data).to eq [0x11, 0x22]
        end
      end

      context 'which form a valid frame with escaped bytes' do
        let(:packet_bytes) { [0x7e, 0x00, 0x02, 0x7d, 0x31, 0x22, 0xcc] }
        it 'gets the correct data' do
          expect(packet.data).to eq [0x11, 0x22]
        end
      end

      context 'with not enough bytes to form a valid frame' do
        let(:packet_bytes) { [0x7e, 0x00] }
        it 'raises an error' do
          expect { packet }.to raise_error(IOError)
        end
      end

      context 'with a missing start byte' do
        let(:packet_bytes) { [0x00, 0x02, 0x7d, 0x31, 0x34, 0x46] }
        it 'raises an error' do
          expect { packet }.to raise_error(IOError)
        end
      end

      context 'with an incorrect checksum' do
        let(:packet_bytes) { [0x7e, 0x00, 0x02, 0x7d, 0x31, 0x34, 0xaa] }
        it 'raises an error' do
          expect { packet }.to raise_error(IOError)
        end
      end

      context 'with an incorrect length' do
        let(:packet_bytes) { [0x7e, 0x00, 0x88, 0x7d, 0x31, 0x34, 0xb9] }
        it 'raises an error' do
          expect { packet }.to raise_error(IOError)
        end
      end
    end

    describe '#==' do
      context 'when the other packet has the same value' do
        let(:other_packet) { described_class.new([0x7e, 0x12, 0x34, 0x56]) }
        it 'finds equality' do
          expect(subject == other_packet).to be_truthy
        end
      end
      context 'when the other packet is different' do
        let(:other_packet) { described_class.new([0x7e, 0x34, 0x56, 0x78]) }
        it 'does not find equality' do
          expect(subject == other_packet).to be_falsey
        end
      end
    end
  end
end
