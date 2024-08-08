require 'sinatra'
require './lib/database'
require './lib/csvreader'

set :bind, '0.0.0.0'
set :port, 3000

get '/' do
  'Rebase Labs!'
end

get '/read' do
  content_type :json
  CsvReader.new('./data.csv').read
end
