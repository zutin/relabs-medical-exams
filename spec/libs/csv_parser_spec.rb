require 'spec_helper'

RSpec.describe 'CsvParser' do
  describe '#parse' do
    let(:data) { JSON.parse(CsvParser.new('./test.csv').parse) }

    it 'reads the correct number of patients' do
      expect(data['patients'].length).to eq(2)
    end

    it 'reads the correct number of doctors' do
      expect(data['doctors'].length).to eq(2)
    end

    it 'reads the correct number of exams' do
      expect(data['exams'].length).to eq(2)
    end

    it 'reads the correct number of results' do
      expect(data['results'].length).to eq(4)
    end
  end
end
