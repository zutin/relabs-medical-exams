require 'spec_helper'

RSpec.describe 'Tests API' do
  describe 'GET /tests' do
    it 'returns http success' do
      get '/tests'
      expect(last_response).to be_ok
    end

    context 'when there are existing tests' do
      it 'returns the correct amount of tests' do
        DataImporter.new('spec/fixtures/test.csv').import
        get '/tests'
        parsed_response = JSON.parse(last_response.body)
        expect(parsed_response.length).to eq(2)
      end

      # rubocop:disable RSpec/MultipleExpectations

      it 'returns the correct tests tokens' do
        DataImporter.new('spec/fixtures/test.csv').import
        get '/tests'
        parsed_response = JSON.parse(last_response.body, symbolize_names: true)
        expect(parsed_response[0][:result_token]).to eq('0W9I67')
        expect(parsed_response[1][:result_token]).to eq('AIWH8Y')
      end

      it 'returns the correct tests dates' do
        DataImporter.new('spec/fixtures/test.csv').import
        get '/tests'
        parsed_response = JSON.parse(last_response.body, symbolize_names: true)
        expect(parsed_response[0][:result_date]).to eq('2021-07-09')
        expect(parsed_response[1][:result_date]).to eq('2021-06-29')
      end

      # rubocop:enable RSpec/MultipleExpectations
    end

    it 'returns an empty array when there are no tests' do
      get '/tests'
      expect(last_response.body).to eq([].to_json)
    end
  end

  describe 'GET /test/:token' do
    context 'when a test by token was found' do
      it 'returns http success' do
        DataImporter.new('spec/fixtures/test.csv').import
        get '/test/0W9I67'
        expect(last_response).to be_ok
      end

      it 'returns the correct test' do
        DataImporter.new('spec/fixtures/test.csv').import
        get '/test/AIWH8Y'
        parsed_response = JSON.parse(last_response.body, symbolize_names: true)
        expect(parsed_response[:result_token]).to eq('AIWH8Y')
      end

      it 'returns the correct test date' do
        DataImporter.new('spec/fixtures/test.csv').import
        get '/test/AIWH8Y'
        parsed_response = JSON.parse(last_response.body, symbolize_names: true)
        expect(parsed_response[:result_date]).to eq('2021-06-29')
      end
    end

    it 'returns an error message when there are no tests' do
      get '/test/123456'
      expect(last_response).to be_not_found
    end
  end
end
