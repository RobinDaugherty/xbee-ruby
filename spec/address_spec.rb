require 'spec_helper'

module XBeeRuby
  RSpec.describe Address do
    describe '#to_a' do
      it 'raises an exception because XBeeAddress is abstract' do
        expect { subject.to_a }.to raise_error
      end
    end
  end
end
