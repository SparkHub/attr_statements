require 'spec_helper'

RSpec.describe AttrStatements::Validations::Error, type: :class do
  describe 'instantiation' do
    it { expect{ described_class.new }.to raise_error(ArgumentError) }
    it { expect(described_class.new(:message)).to be_truthy }
    it { expect(described_class.new(:message, {})).to be_truthy }
  end

  describe 'accessors' do
    context '#message' do
      context 'as string' do
        it { expect(described_class.new(:message).message).to eq(:message) }
      end

      context 'as symbol' do
        it { expect(described_class.new('message').message).to eq(:message) }
      end
    end

    context 'options' do
      it { expect(described_class.new(:message, { my: :option }).options).to eq(my: :option) }
    end
  end
end
