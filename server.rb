require 'sinatra'

set :bind, '0.0.0.0'
set :port, 3000

get '/' do
  'Rebase Labs!'
end

get '/sum' do
  a = params[:a].to_i
  b = params[:b].to_i
  (a + b).to_s
end
