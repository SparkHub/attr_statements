require 'spec_helper'

RSpec.describe AttrStatements do
  context 'version' do
    it { expect(described_class::VERSION).not_to be(nil) }
  end
end
