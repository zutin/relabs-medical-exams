require 'spec_helper'
require 'data_importer'

RSpec.describe 'Tests API' do
  describe 'GET /tests' do
    it 'returns all tests' do
      DataImporter.new('./test.csv').import
      get '/tests'
      parsed_response = JSON.parse(last_response.body)
      expect(parsed_response.length).to eq(2)
    end

    it 'returns an empty array when there are no tests' do
      get '/tests'
      expect(last_response.body).to eq([].to_json)
    end
  end

  describe 'GET /test/:token' do
    it 'returns a test by token' do
      DataImporter.new('./test.csv').import
      get '/test/AIWH8Y'
      parsed_response = JSON.parse(last_response.body, symbolize_names: true)
      expect(parsed_response[:result_token]).to eq('AIWH8Y')
    end

    it 'returns an error message when there are no tests' do
      get '/test/123456'
      expect(last_response.body).to eq({ error: 'Exam not found or invalid token provided' }.to_json)
    end
  end
end
