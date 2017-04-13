require 'spec_helper'
require 'securerandom'

RSpec.describe AttrStatements, type: :module do
  let(:fake_class) do
    class FakeClass
      include AttrStatements
      attr_statement :city, String, presence: true, length: { maximum: 10 }
      def initialize(attrs = {})
        attrs.each { |attr, value| public_send("#{attr}=", value) }
      end
    end
    return FakeClass
  end

  describe 'class methods' do
    context '#attr_statements' do
      it { expect(fake_class.attr_statements).to contain_exactly(:city) }
    end

    context 'attribute accessors' do
      subject { fake_class.city }

      it { expect(subject).to be_a(described_class::Attribute) }
      it { expect(subject.key).to eq(:city) }
      it { expect(subject.class_type).to eq(String) }
      it { expect(subject.options[:presence]).to eq(true) }
      it { expect(subject.length[:maximum]).to eq(10) }
    end
  end

  describe 'instance methods' do
    context 'attribute value accessor' do
      subject { fake_class.new(city: 'Gotham') }

      it { expect(subject.city).to eq('Gotham') }
    end

    context '#errors' do
      subject { fake_class.new }

      it { expect(subject.errors).to be_a(ActiveModel::Errors) }
    end

    context '#valid?' do
      context 'with invalid parameters' do
        subject { fake_class.new(city: nil) }

        it { expect(subject.valid?).to eq(false) }

        it 'should empty @errors for every calls' do
          subject.valid?
          expect(subject.errors.empty?).to eq(false)
          subject.city = 'Gotham'
          subject.valid?
          expect(subject.errors.empty?).to eq(true)
        end
      end

      context 'with valid parameters' do
        subject { fake_class.new(city: 'Gotham') }

        it { expect(subject.valid?).to eq(true) }
      end
    end
  end

  describe 'validation management' do
    context 'valid' do
      subject { fake_class.new(city: 'Gotham') }

      it 'should not add error' do
        expect(subject.valid?).to eq(true)
        expect(subject.errors.empty?).to eq(true)
      end
    end

    context '#type' do
      context 'invalid' do
        subject { fake_class.new(city: 123) }

        it 'should add an error' do
          expect(subject.valid?).to eq(false)
          expect(subject.errors.added?(:city, :type, class: String)).to eq(true)
        end
      end
    end

    context '#presence' do
      context 'invalid' do
        subject { fake_class.new(city: nil) }

        it 'should add an error' do
          expect(subject.valid?).to eq(false)
          expect(subject.errors.added?(:city, :blank)).to eq(true)
        end
      end
    end

    context '#length' do
      context 'invalid' do
        subject { fake_class.new(city: SecureRandom.hex) } # 32

        it 'should add an error' do
          expect(subject.valid?).to eq(false)
          expect(subject.errors.added?(:city, :too_long, count: 10)).to eq(true)
        end
      end
    end
  end
end
