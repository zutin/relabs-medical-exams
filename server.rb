require 'sinatra'

set :bind, '0.0.0.0'
set :port, 3000

get '/' do
  'Rebase Labs!'
end
