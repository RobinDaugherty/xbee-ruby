require 'spec_helper'

module XBeeRuby
  RSpec.describe TxRequest do
    subject { TxRequest.new Address64.new(0x11, 0x22, 0x33, 0x44, 0x55, 0x66, 0x77, 0x88), [0x12, 0x34] }

    its(:frame_type) { is_expected.to eq 0x10 }
    its(:address64) { is_expected.to eq Address64.new(0x11, 0x22, 0x33, 0x44, 0x55, 0x66, 0x77, 0x88) }
    its(:address16) { is_expected.to eq Address16::BROADCAST }
    its(:data) { is_expected.to eq [0x12, 0x34] }
    its(:options) { is_expected.to eq 0 }
    its(:radius) { is_expected.to eq 0 }
    its(:frame_data) { is_expected.to eq [0x11, 0x22, 0x33, 0x44, 0x55, 0x66, 0x77, 0x88, 0xff, 0xfe, 0x00, 0x00, 0x12, 0x34]}

    describe 'if :options is specified' do
      subject { TxRequest.new Address64::BROADCAST, [], options: 0xab }
      its(:options) { is_expected.to eq 0xab }
    end

    describe 'if :radius are specified' do
      subject { TxRequest.new Address64::BROADCAST, [], radius: 123 }
      its(:radius) { is_expected.to eq 123 }
    end
  end
end
