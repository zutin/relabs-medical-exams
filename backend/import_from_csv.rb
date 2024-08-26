require 'optparse'
require_relative 'lib/data_importer'

options = {}
options[:file] = nil

OptionParser.new do |parser|
  parser.banner = 'Usage: ruby import_from_csv.rb [options]'

  parser.on('-f', '--file FILE', 'CSV file to import') do |file|
    options[:file] = file
  end

  parser.on('-h', '--help', 'Prints this help screen') do
    puts parser
    exit
  end
end.parse!

if options[:file].nil?
  puts 'Please provide a CSV file to import with -f option'
  exit
end

unless File.exist?(options[:file])
  puts "File not found - #{options[:file]}"
  exit
end

begin
  Database.create
  csv = DataImporter.new(options[:file])
  puts 'Data is currently being imported from CSV file...'
  csv.import
  puts 'Data imported successfully!'
rescue StandardError => e
  puts "An error occurred: #{e.message}"
end
