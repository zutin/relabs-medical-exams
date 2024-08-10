require 'sinatra'
require './lib/database'
require './lib/csvreader'
require './lib/patient'

set :bind, '0.0.0.0'
set :port, 3000

get '/' do
  'Rebase Labs!'
end

get '/read' do
  content_type :json
  CsvReader.new('./data.csv').read
end

get '/createdb' do
  Database.create
  'Database created!'
end

get '/dropdb' do
  Database.drop
  'Database dropped!'
end

get '/trytosave' do
  rows = CSV.read('./data.csv', col_sep: ';', headers: true)

  rows.each do |row|
    test = Patient.new(
      cpf: row[0],
      name: row[1],
      email: row[2],
      birthday: row[3],
      address: row[4],
      city: row[5],
      state: row[6]
    )
    test.save
  end

  'Data saved!'
end

get '/patients' do
  content_type :json
  Patient.all.to_json
end
