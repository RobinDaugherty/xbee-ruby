require 'spec_helper'

module XBeeRuby
  RSpec.describe Packet do
    subject { Packet.new [0x7e, 0x12, 0x34, 0x56] }

    its(:data) { is_expected.to eq [0x7e, 0x12, 0x34, 0x56] }
    its(:length) { is_expected.to eq 0x04 }
    its(:checksum) { is_expected.to eq 0xe5 }
    its(:bytes) { is_expected.to eq [0x7e, 0x00, 0x04, 0x7e, 0x12, 0x34, 0x56, 0xe5] }
    its(:bytes_escaped) { is_expected.to eq [0x7e, 0x00, 0x04, 0x7d, 0x5e, 0x12, 0x34, 0x56, 0xe5] }

    describe '::special_byte?' do
      specify { expect(Packet.special_byte?(0x7e)).to be_truthy }
      specify { expect(Packet.special_byte?(0x7d)).to be_truthy }
      specify { expect(Packet.special_byte?(0x11)).to be_truthy }
      specify { expect(Packet.special_byte?(0x13)).to be_truthy }
      specify { expect(Packet.special_byte?(0x00)).to be_falsey }
    end

    describe '::unescape' do
      specify { expect(Packet.unescape([0x00, 0x7d, 0x31, 0x22])).to eq([0x00, 0x11, 0x22]) }
    end

    describe '::from_bytes' do
      describe 'which form a valid frame' do
        subject { Packet.from_bytes [0x7e, 0x00, 0x02, 0x11, 0x22, 0xcc] }
        its(:data) { is_expected.to eq [0x11, 0x22] }
      end

      describe 'which form a valid frame with escaped bytes' do
        subject { Packet.from_bytes [0x7e, 0x00, 0x02, 0x7d, 0x31, 0x22, 0xcc] }
        its(:data) { is_expected.to eq [0x11, 0x22] }
      end

      describe 'which are not enough to form a valid frame' do
        specify { expect { Packet.from_bytes [0x7e, 0x00] }.to raise_error ArgumentError }
      end

      describe 'with a missing start byte' do
        specify { expect { Packet.from_bytes [0x00, 0x02, 0x7d, 0x31, 0x34, 0x46] }.to raise_error ArgumentError }
      end

      describe 'with a wrong checksum' do
        specify { expect { Packet.from_bytes [0x7e, 0x00, 0x02, 0x7d, 0x31, 0x34, 0xaa] }.to raise_error ArgumentError }
      end

      describe 'with a wrong length' do
        specify { expect { Packet.from_bytes [0x7e, 0x00, 0x88, 0x7d, 0x31, 0x34, 0xb9] }.to raise_error ArgumentError }
      end
    end

    describe '::from_byte_enum' do
      describe 'which provides a valid frame' do
        subject { Packet.from_byte_enum [0x7e, 0x00, 0x02, 0x11, 0x22, 0xcc].to_enum }
        its(:data) { is_expected.to eq [0x11, 0x22] }
      end

      describe 'which provides a valid frame with escaped bytes' do
        subject { Packet.from_byte_enum [0x7e, 0x00, 0x02, 0x7d, 0x31, 0x22, 0xcc].to_enum }
        its(:data) { is_expected.to eq [0x11, 0x22] }
      end

      describe 'which does not provide enough bytes to form a valid frame' do
        specify { expect { Packet.from_byte_enum [0x7e, 0x00].to_enum }.to raise_error IOError }
      end

      describe 'with a missing start byte' do
        specify { expect { Packet.from_byte_enum [0x00, 0x02, 0x7d, 0x31, 0x34, 0x46].to_enum }.to raise_error IOError }
      end

      describe 'with a wrong checksum' do
        specify { expect { Packet.from_byte_enum [0x7e, 0x00, 0x02, 0x7d, 0x31, 0x34, 0xaa].to_enum }.to raise_error IOError }
      end

      describe 'with a wrong length' do
        specify { expect { Packet.from_byte_enum [0x7e, 0x00, 0x88, 0x7d, 0x31, 0x34, 0xb9].to_enum }.to raise_error IOError }
      end
    end

    describe '#==' do
      it { is_expected.to eq(Packet.new([0x7e, 0x12, 0x34, 0x56])) }
    end
  end
end
