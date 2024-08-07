require 'capybara/rspec'
require 'capybara/dsl'
require 'rack/test'
require './server'

Capybara.app = Sinatra::Application

RSpec.configure do |config|
  config.include Capybara::DSL
  config.include Rack::Test::Methods
end
