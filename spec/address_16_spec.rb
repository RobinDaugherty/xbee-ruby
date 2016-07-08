require 'spec_helper'

module XBeeRuby
  RSpec.describe Address16 do
    subject(:address16) { described_class.new 0x12, 0x34 }

    describe '#to_s' do
      subject(:to_s) { address16.to_s }
      it 'formats the address as a string' do
        expect(to_s).to eq '1234'
      end
    end

    describe '#to_a' do
      subject(:to_a) { address16.to_a }
      it 'returns the address as an array of bytes' do
        expect(to_a).to eq [0x12, 0x34]
      end
    end

    describe '.from_s' do
      subject(:address16) { described_class.from_s(address_string) }

      context 'with a valid address string' do
        let(:address_string) { '1a2B' }
        it 'correctly parses the address' do
          expect(address16.to_a).to eq [0x1a, 0x2b]
        end
      end

      context 'with a valid address string with separators' do
        let(:address_string) { '1a:2B' }
        it 'correctly parses the address' do
          expect(address16.to_a).to eq [0x1a, 0x2b]
        end
      end

      context 'with an invalid address string' do
        context 'blank' do
          let(:address_string) { '' }
          it 'raises an ArgumentError' do
            expect { address16 }.to raise_error(ArgumentError)
          end
        end
        context 'too short' do
          let(:address_string) { '12' }
          it 'raises an ArgumentError' do
            expect { address16 }.to raise_error(ArgumentError)
          end
        end
        context 'too long' do
          let(:address_string) { '12:34:56' }
          it 'raises an ArgumentError' do
            expect { address16 }.to raise_error(ArgumentError)
          end
        end
        context 'not a multiple of 8 bits' do
          let(:address_string) { 'bad' }
          it 'raises an ArgumentError' do
            expect { address16 }.to raise_error(ArgumentError)
          end
        end
      end
    end

    describe '.from_a' do
      subject(:address16) { described_class.from_a(address_array) }

      describe 'with a valid address array' do
        let(:address_array) { [0x98, 0x76] }
        it 'correctly parses the address' do
          expect(address16.to_a).to eq [0x98, 0x76]
        end
      end

      describe 'with an invalid address array' do
        context 'empty' do
          let(:address_array) { [] }
          it 'raises an ArgumentError' do
            expect { address16 }.to raise_error(ArgumentError)
          end
        end
        context 'too short' do
          let(:address_array) { [0] }
          it 'raises an ArgumentError' do
            expect { address16 }.to raise_error(ArgumentError)
          end
        end
        context 'too long' do
          let(:address_array) { [0, 127, 128] }
          it 'raises an ArgumentError' do
            expect { address16 }.to raise_error(ArgumentError)
          end
        end
        context 'not an unsigned single-byte int' do
          let(:address_array) { [0, 256] }
          it 'raises an ArgumentError' do
            expect { address16 }.to raise_error(ArgumentError)
          end
        end
      end
    end

    describe '#==' do
      context 'when the other address has the same value' do
        let(:other_address) { described_class.new(0x12, 0x34) }
        it 'finds equality' do
          expect(subject == other_address).to be_truthy
        end
      end
      context 'when the other address is different' do
        let(:other_address) { described_class.new(0x13, 0x33) }
        it 'does not find equality' do
          expect(subject == other_address).to be_falsey
        end
      end
    end

    describe '.BROADCAST' do
      specify { expect(Address16::BROADCAST).to eq(Address16.new(0xff, 0xfe))}
    end
  end
end
