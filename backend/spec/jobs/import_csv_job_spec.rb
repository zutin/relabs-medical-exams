require 'spec_helper'
require 'sidekiq/testing'

Sidekiq::Testing.fake!

RSpec.describe ImportCsvJob, type: :job do
  describe '#perform' do
    let(:file) { File.read('spec/fixtures/test.csv') }

    before do
      Sidekiq::Worker.clear_all
    end

    it 'enqueues the job' do
      expect { described_class.perform_async(file) }.to change(described_class.jobs, :size).by(1)
    end
  end
end
