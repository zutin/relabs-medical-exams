require 'sinatra'
require './lib/data_importer'
require './lib/database'

set :bind, '0.0.0.0'
set :port, 3000

get '/' do
  'Rebase Labs!'
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
