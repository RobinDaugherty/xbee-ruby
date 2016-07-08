require 'spec_helper'

module XBeeRuby
  RSpec.describe Address64 do
    subject(:address64) { described_class.new 0x11, 0x22, 0x33, 0x44, 0x55, 0x66, 0x77, 0x88 }

    describe '#to_s' do
      subject(:to_s) { address64.to_s }
      it 'formats the address as a string' do
        expect(to_s).to eq '1122334455667788'
      end
    end

    describe '#to_a' do
      subject(:to_a) { address64.to_a }
      it 'returns the address as an array of bytes' do
        expect(to_a).to eq [0x11, 0x22, 0x33, 0x44, 0x55, 0x66, 0x77, 0x88]
      end
    end

    describe '.from_s' do
      subject(:address64) { described_class.from_s(address_string) }

      describe 'with a valid address string' do
        let(:address_string) { '1a2B3c4D5566eeFF' }
        it 'correctly parses the address' do
          expect(address64.to_a).to eq [0x1a, 0x2b, 0x3c, 0x4d, 0x55, 0x66, 0xee, 0xff]
        end
      end

      describe 'with a valid address string with separators' do
        let(:address_string) { '1a:2B:3c:4D:55:66:ee:FF' }
        it 'correctly parses the address' do
          expect(address64.to_a).to eq [0x1a, 0x2b, 0x3c, 0x4d, 0x55, 0x66, 0xee, 0xff]
        end
      end

      context 'with an invalid address string' do
        context 'blank' do
          let(:address_string) { '' }
          it 'raises an ArgumentError' do
            expect { address64 }.to raise_error(ArgumentError)
          end
        end
        context 'too short' do
          let(:address_string) { '12' }
          it 'raises an ArgumentError' do
            expect { address64 }.to raise_error(ArgumentError)
          end
        end
        context 'too long' do
          let(:address_string) { '11:22:33:44:55:66:77:88:99' }
          it 'raises an ArgumentError' do
            expect { address64 }.to raise_error(ArgumentError)
          end
        end
        context 'not a multiple of 8 bits' do
          let(:address_string) { 'bad' }
          it 'raises an ArgumentError' do
            expect { address64 }.to raise_error(ArgumentError)
          end
        end
      end
    end

    describe '.from_a' do
      subject(:address64) { described_class.from_a(address_array) }

      context 'with a valid address array' do
        let(:address_array) { [0x11, 0x22, 0x33, 0x44, 0x55, 0x66, 0x77, 0x88] }
        it 'correctly parses the address' do
          expect(address64.to_a).to eq [0x11, 0x22, 0x33, 0x44, 0x55, 0x66, 0x77, 0x88]
        end
      end

      describe 'with an invalid address array' do
        context 'empty' do
          let(:address_array) { [] }
          it 'raises an ArgumentError' do
            expect { address64 }.to raise_error(ArgumentError)
          end
        end
        context 'too short' do
          let(:address_array) { [0] }
          it 'raises an ArgumentError' do
            expect { address64 }.to raise_error(ArgumentError)
          end
        end
        context 'too long' do
          let(:address_array) { [1, 2, 3, 4, 5, 6, 7, 8, 9] }
          it 'raises an ArgumentError' do
            expect { address64 }.to raise_error(ArgumentError)
          end
        end
        context 'not an unsigned single-byte int' do
          let(:address_array) { [0, 256] }
          it 'raises an ArgumentError' do
            expect { address64 }.to raise_error(ArgumentError)
          end
        end
      end
    end

    describe '#==' do
      context 'when the other address has the same value' do
        let(:other_address) { described_class.new(0x11, 0x22, 0x33, 0x44, 0x55, 0x66, 0x77, 0x88) }
        it 'finds equality' do
          expect(subject == other_address).to be_truthy
        end
      end
      context 'when the other address is different' do
        let(:other_address) { described_class.new(0x22, 0x33, 0x44, 0x55, 0x66, 0x77, 0x88, 0x99) }
        it 'does not find equality' do
          expect(subject == other_address).to be_falsey
        end
      end
    end

    describe '::BROADCAST' do
      it 'returns an Address64 object with the correct address' do
        expect(Address64::BROADCAST).to eq(Address64.new(0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xff, 0xff))
      end
    end

    describe '::COORDINATOR' do
      it 'returns an Address64 object with the correct address' do
        expect(Address64::COORDINATOR).to eq(Address64.new(0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00))
      end
    end
  end
end
