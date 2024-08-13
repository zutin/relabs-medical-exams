require 'spec_helper'

RSpec.describe 'Import API' do
  describe 'POST /import' do
    let(:file) { Rack::Test::UploadedFile.new('spec/fixtures/test.csv', 'text/csv') }
    let(:conn) { Database.connect }

    context 'when the file is a CSV' do
      it 'successfully imports the file' do
        post('/import', file:)

        count = conn.exec('SELECT * FROM patients').count
        expect(count).to eq(2)
      end
    end

    context 'when the file is not found' do
      it 'returns a bad request status' do
        post('/import')

        expect(last_response).to be_bad_request
      end
    end

    context 'when the file is not a CSV' do
      it 'returns a bad request status' do
        file = Rack::Test::UploadedFile.new('spec/fixtures/docs-para-estudo.xml', 'text/xml')
        post('/import', file:)

        expect(last_response).to be_bad_request
      end
    end
  end
end
