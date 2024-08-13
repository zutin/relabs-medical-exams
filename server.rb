require 'sinatra'
require 'rack/handler/puma'
require_relative 'lib/api_controller'
require_relative 'lib/database'
require_relative 'lib/data_importer'

get '/tests' do
  response = ApiController.new
  content_type :json
  response.tests.to_json
rescue StandardError => e
  status :internal_server_error
  { error: e.message }.to_json
end

get '/test/:token' do
  response = ApiController.new
  content_type :json
  response.test(params[:token]).to_json
rescue StandardError => e
  status :internal_server_error
  { error: e.message }.to_json
end

get '/dropdb' do
  Database.drop
  'Database dropped!'
end

get '/import' do
  content_type :json
  Database.create
  DataImporter.new('./data.csv').import
end

unless ENV['RACK_ENV'] == 'test'
  Rack::Handler::Puma.run(
    Sinatra::Application,
    Port: 3000,
    Host: '0.0.0.0'
  )
end
