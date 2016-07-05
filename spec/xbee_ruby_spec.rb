require 'spec_helper'

RSpec.describe XBeeRuby do
  specify { expect(XBeeRuby::VERSION).not_to be_nil }
end
