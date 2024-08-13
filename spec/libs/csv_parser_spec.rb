require 'spec_helper'

RSpec.describe 'CsvParser' do
  describe '#parse' do
    let(:data) { CsvParser.new('spec/fixtures/test.csv').parse }

    it 'returns the correct number of patients' do
      expect(data['patients'].length).to eq(2)
    end

    it 'returns the correct number of doctors' do
      expect(data['doctors'].length).to eq(2)
    end

    it 'returns the correct number of exams' do
      expect(data['exams'].length).to eq(2)
    end

    it 'returns the correct number of results' do
      expect(data['results'].length).to eq(4)
    end
  end
end
