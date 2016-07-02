require 'spec_helper'

module XBeeRuby
  describe Address do
    describe '#to_a' do
      it 'should raise an exception because XBeeAddress is abstract' do
        expect { subject.to_a }.to raise_error
      end
    end
  end
end
