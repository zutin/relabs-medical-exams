require 'rspec'
require 'rack/test'
require_relative '../server'
require_relative '../lib/database'

RSpec.configure do |config|
  def app
    Sinatra::Application
  end

  config.include Rack::Test::Methods

  config.before(:each) do
    Database.create
  end

  config.after(:each) do
    Database.drop
  end
end
