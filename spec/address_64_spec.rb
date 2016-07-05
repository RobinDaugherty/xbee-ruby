require 'spec_helper'

module XBeeRuby
  RSpec.describe Address64 do
    subject { Address64.new 0x11, 0x22, 0x33, 0x44, 0x55, 0x66, 0x77, 0x88 }

    describe '#to_s' do
      its(:to_s) { is_expected.to eq '1122334455667788' }
    end

    describe '#to_a' do
      its(:to_a) { is_expected.to eq [0x11, 0x22, 0x33, 0x44, 0x55, 0x66, 0x77, 0x88] }
    end

    describe '::from_s' do
      describe 'with a valid address string' do
        subject { Address64.from_s '1a2B3c4D5566eeFF' }
        its(:to_a) { is_expected.to eq [0x1a, 0x2b, 0x3c, 0x4d, 0x55, 0x66, 0xee, 0xff] }
      end

      describe 'with a valid address string with separators' do
        subject { Address64.from_s '1a:2B:3c:4D:55:66:ee:FF' }
        its(:to_a) { is_expected.to eq [0x1a, 0x2b, 0x3c, 0x4d, 0x55, 0x66, 0xee, 0xff] }
      end

      describe 'with an invalid address string' do
        specify { expect { Address64.from_s '' }.to raise_error ArgumentError }
        specify { expect { Address64.from_s '12' }.to raise_error ArgumentError }
        specify { expect { Address64.from_s '11:22:33:44:55:66:77:88:99' }.to raise_error ArgumentError }
        specify { expect { Address64.from_s 'bad' }.to raise_error ArgumentError }
      end
    end

    describe '::from_a' do
      describe 'with a valid address array' do
        subject { Address64.from_a [0x11, 0x22, 0x33, 0x44, 0x55, 0x66, 0x77, 0x88] }
        its(:to_a) { is_expected.to eq [0x11, 0x22, 0x33, 0x44, 0x55, 0x66, 0x77, 0x88] }
      end

      describe 'with an invalid address array' do
        specify { expect { Address64.from_a [] }.to raise_error ArgumentError }
        specify { expect { Address64.from_a [0] }.to raise_error ArgumentError }
        specify { expect { Address64.from_a [0, 256] }.to raise_error ArgumentError }
      end
    end

    describe '#==' do
      it { is_expected.to eq(Address64.new(0x11, 0x22, 0x33, 0x44, 0x55, 0x66, 0x77, 0x88)) }
    end

    describe '::BROADCAST' do
      specify { expect(Address64::BROADCAST).to eq(Address64.new(0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xff, 0xff)) }
    end

    describe '::COORDINATOR' do
      specify { expect(Address64::COORDINATOR).to eq(Address64.new(0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00)) }
    end
  end
end
