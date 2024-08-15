require 'spec_helper'

RSpec.describe 'ApiController' do
  let(:api) { ApiController.new }

  describe '#tests' do
    context 'when there are tests' do
      it 'returns all tests' do
        DataImporter.new('spec/fixtures/test.csv').import
        result = api.tests
        expect(result.length).to eq(2)
      end
    end

    context 'when there are no tests' do
      it 'returns an empty array' do
        result = api.tests
        expect(result).to eq([])
      end
    end
  end

  describe '#test' do
    context 'when the test exists' do
      it 'returns the test' do
        DataImporter.new('spec/fixtures/test.csv').import
        result = api.test('AIWH8Y')
        expect(result[:result_token]).to eq('AIWH8Y')
      end
    end

    context 'when the test does not exist' do
      it 'returns nil' do
        result = api.test('invalid')
        expect(result).to be_nil
      end
    end
  end
end
