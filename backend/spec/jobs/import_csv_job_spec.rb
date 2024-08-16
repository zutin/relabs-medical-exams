require 'spec_helper'
require 'sidekiq/testing'

Sidekiq::Testing.fake!

RSpec.describe ImportCsvJob, type: :job do
  describe '#perform' do
    let(:file) { File.read('spec/fixtures/test.csv') }
    # let(:importer) { instance_double(DataImporter) }

    before do
      Sidekiq::Worker.clear_all
    end

    it 'enqueues the job' do
      expect { described_class.perform_async(file) }.to change(described_class.jobs, :size).by(1)
    end

    # it 'calls the DataImporter.import method' do
    #   allow(DataImporter).to receive(:new).and_return(importer)
    #   allow(importer).to receive(:import)

    #   described_class.perform_async(file)
    #   described_class.drain

    #   expect(DataImporter).to have_received(:new).with(file)
    #   expect(importer).to have_received(:import)
    # end
  end
end
