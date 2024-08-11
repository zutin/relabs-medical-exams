require 'sinatra'
require 'rack/handler/puma'

require './lib/data_importer'
require './lib/database'
require 'csv'

get '/tests' do
  rows = CSV.read('./data.csv', col_sep: ';')

  columns = rows.shift

  rows.map do |row|
    row.each_with_object({}).with_index do |(cell, acc), idx|
      column = columns[idx]
      acc[column] = cell
    end
  end.to_json
end

get '/createdb' do
  Database.create
  'Database created!'
end

get '/dropdb' do
  Database.drop
  'Database dropped!'
end

get '/import' do
  content_type :json
  DataImporter.new('./data.csv').import
end

get '/data' do
  content_type :json
  conn = Database.connect
  data = { 'patients' => conn.exec('SELECT * FROM patients').to_a,
           'doctors' => conn.exec('SELECT * FROM doctors').to_a }
  conn.close
  data.to_json
end

unless ENV['RACK_ENV'] == 'test'
  Rack::Handler::Puma.run(
    Sinatra::Application,
    Port: 3000,
    Host: '0.0.0.0'
  )
end
