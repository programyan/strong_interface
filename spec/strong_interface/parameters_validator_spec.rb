# frozen_string_literal: true

RSpec.describe StrongInterface::ParametersValidator do

  describe '#valid?' do
    subject(:valid?) { described_class.new(interface_method, klass_method).valid? }

    context 'when interface_method has rest only' do
      let(:interface_method) { method(def my_method(*); end) }

      context 'and klass_method without params' do
        let(:klass_method) { method(def my_method; end) }

        it { is_expected.to eq true }
      end

      context 'and klass_method with any_params' do
        let(:klass_method) { method(def my_method(a, b = 1, c:, d: 2); end) }

        it { is_expected.to eq true }
      end
    end

    context 'when interface_method has no params' do
      let(:interface_method) { method(def my_method; end) }

      context 'and klass_method without params' do
        let(:klass_method) { method(def my_method; end) }

        it { is_expected.to eq true }
      end

      context 'and klass_method with any_params' do
        let(:klass_method) { method(def my_method(a, b = 1, c:, d: 2); end) }

        it { is_expected.to eq false }
      end
    end

    context 'when interface method has different params' do
      let(:interface_method) { method(def my_method(a, b, c:, d:); end) }

      context 'with rest only' do
        let(:klass_method) { method(def my_method(*); end) }

        it { is_expected.to eq true }
      end

      context 'when not enough params' do
        let(:klass_method) { method(def my_method(a, c:); end) }

        it { is_expected.to eq false }
      end

      context 'when optional params' do
        let(:klass_method) { method(def my_method(a, b = 1, c:, d: 2); end) }

        it { is_expected.to eq true }
      end

      context 'with all params' do
        let(:klass_method) { method(def my_method(a, b, c:, d:); end) }

        it { is_expected.to eq true }
      end

      context 'with other names' do
        let(:klass_method) { method(def my_method(e, f, g:, h:); end) }

        it { is_expected.to eq true }
      end

      context 'when other params' do
        let(:klass_method) { method(def my_method(a:, b:, c:, d:); end) }

        it { is_expected.to eq false }
      end
    end
  end
end
