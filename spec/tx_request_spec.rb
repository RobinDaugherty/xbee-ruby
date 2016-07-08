require 'spec_helper'

module XBeeRuby
  RSpec.describe TxRequest do
    subject(:request) { TxRequest.new destination_address, payload }
    let(:destination_address) { Address64.new(0x11, 0x22, 0x33, 0x44, 0x55, 0x66, 0x77, 0x88) }
    let(:payload) { [0x12, 0x34] }

    describe '#new' do
      it 'sets the correct frame_type' do
        expect(request.frame_type).to eq 0x10
      end
      it 'sets the correct address64' do
        expect(request.address64).to eq Address64.new(0x11, 0x22, 0x33, 0x44, 0x55, 0x66, 0x77, 0x88)
      end
      it 'sets the correct address16' do
        expect(request.address16).to eq Address16::BROADCAST
      end
      it 'sets the correct data' do
        expect(request.data).to eq [0x12, 0x34]
      end
      it 'sets the correct options' do
        expect(request.options).to eq 0
      end
      it 'sets the correct radius' do
        expect(request.radius).to eq 0
      end
      it 'sets the correct frame_data' do
        expect(request.frame_data).to eq [0x11, 0x22, 0x33, 0x44, 0x55, 0x66, 0x77, 0x88, 0xff, 0xfe, 0x00, 0x00, 0x12, 0x34]
      end

      context 'if :options is specified' do
        subject(:request) { TxRequest.new Address64::BROADCAST, [], options: 0xab }
        it 'sets the correct options' do
          expect(request.options).to eq 0xab
        end
      end

      context 'if :radius is specified' do
        subject(:request) { TxRequest.new Address64::BROADCAST, [], radius: 123 }
        it 'sets the correct radius' do
          expect(request.radius).to eq 123
        end
      end
    end
  end
end
