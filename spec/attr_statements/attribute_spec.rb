require 'spec_helper'

RSpec.describe AttrStatements::Attribute, type: :class do
  describe 'instantiation' do
    it { expect{ described_class.new }.to raise_error(ArgumentError) }
    it { expect{ described_class.new(:key) }.to raise_error(ArgumentError) }
    it { expect{ described_class.new(:key, String, nil) }.to raise_error(ArgumentError) }
    it { expect{ described_class.new(:key, 'NonExistingClass', {}) }.to raise_error(NameError) }
    it { expect(described_class.new(:key, String)).to be_truthy }
    it { expect(described_class.new('key', String)).to be_truthy }
    it { expect(described_class.new(:key, 'String')).to be_truthy }
    it { expect(described_class.new(:key, String, {})).to be_truthy }
  end

  describe 'accessors' do
    context '#key' do
      context 'as symbol' do
        subject { Factory.statement_attribute(key: :key) }

        it { expect(subject.key).to eq(:key) }
      end

      context 'as string' do
        subject { Factory.statement_attribute(key: 'key') }

        it { expect(subject.key).to eq(:key) }
      end
    end

    context '#class_type' do
      context 'as class' do
        before(:each) do
          class ExistingAttributeClass
          end
        end
        subject { Factory.statement_attribute(class_type: ExistingAttributeClass) }

        it { expect(subject.class_type).to eq(ExistingAttributeClass) }
      end

      context 'as string' do
        subject { Factory.statement_attribute(class_type: 'String') }

        it { expect(subject.class_type).to eq(String) }
      end
    end

    context '#options' do
      context 'with indifferent access' do
        subject { Factory.statement_attribute(options: { 'presence' => true }) }

        it { expect(subject.options[:presence]).to eq(true) }
      end

      context 'with non valid validators' do
        subject { Factory.statement_attribute(options: { my: :option }) }

        it { expect(subject.options[:my]).to be_nil }
      end

      context 'with valid validators' do
        subject { Factory.statement_attribute(options: { presence: true }) }

        it { expect(subject.options[:presence]).to eq(true) }
      end
    end
  end

  describe 'instance methods' do
    context '#presence?' do
      it { expect(Factory.statement_attribute(options: { presence: true }).presence?).to eq(true) }
      it { expect(Factory.statement_attribute(options: {}).presence?).to eq(false) }
      it { expect(Factory.statement_attribute(options: { presence: false }).presence?).to eq(false) }
    end

    context '#length' do
      it { expect(Factory.statement_attribute(options: { length: 42 }).length).to eq(42) }
      it { expect(Factory.statement_attribute(options: {}).length).to eq({}) }
      it { expect(Factory.statement_attribute(options: { length: {} }).length).to be_a(Hash) }
    end
  end
end
