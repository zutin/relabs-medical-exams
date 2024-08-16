require 'sidekiq'
require_relative '../lib/data_importer'

class ImportCsvJob
  include Sidekiq::Job

  def perform(file)
    Database.create
    logger.info 'Importing data...'
    importer = DataImporter.new(file)
    importer.import
    logger.info 'Data imported successfully!'
  rescue PG::Error => e
    logger.error "Database error: #{e.message}"
    raise
  end
end
