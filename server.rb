require 'sinatra'
require 'rack/handler/puma'
require_relative 'lib/api_controller'
require_relative 'lib/database'

get '/tests' do
  response = ApiController.new

  content_type :json
  status :ok
  response.tests.to_json
rescue StandardError => e
  status :internal_server_error
  { error: e.message }.to_json
end

get '/test/:token' do
  response = ApiController.new
  result = response.test(params[:token])

  return status :not_found if result.nil?

  content_type :json
  status :ok
  result.to_json
rescue StandardError => e
  status :internal_server_error
  { error: e.message }.to_json
end

post '/import' do
  unless params[:file] && params[:file][:tempfile] && params[:file][:filename].end_with?('.csv')
    return status :bad_request
  end

  file = params[:file][:tempfile]
  response = ApiController.new
  response.import(file)
  status :ok
rescue StandardError => e
  status :internal_server_error
  { error: e.message }.to_json
end

get '/dropdb' do
  Database.drop
  'Database dropped!'
end

get '/createdb' do
  Database.create
  'Database created!'
end

unless ENV['RACK_ENV'] == 'test'
  Rack::Handler::Puma.run(
    Sinatra::Application,
    Port: 3000,
    Host: '0.0.0.0'
  )
end
