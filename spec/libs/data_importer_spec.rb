require 'spec_helper'

RSpec.describe 'DataImporter' do
  describe '#import' do
    let(:importer) { DataImporter.new('./test.csv') }
    let(:conn) { Database.connect }

    it 'imports the patients from the csv file' do
      importer.import
      count = conn.exec('SELECT * FROM patients').count
      conn.close
      expect(count).to eq(2)
    end

    it 'imports the doctors from the csv file' do
      importer.import
      count = conn.exec('SELECT * FROM doctors').count
      conn.close
      expect(count).to eq(2)
    end

    it 'imports the exams from the csv file' do
      importer.import
      count = conn.exec('SELECT * FROM exams').count
      conn.close
      expect(count).to eq(2)
    end

    it 'imports the exams results from the csv file' do
      importer.import
      count = conn.exec('SELECT * FROM exam_results').count
      conn.close
      expect(count).to eq(4)
    end
  end
end
