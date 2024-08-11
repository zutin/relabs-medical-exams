require 'spec_helper'
require 'database'

RSpec.describe 'Server' do
  describe 'GET /' do
    it 'returns Rebase Labs!' do
      pending 'Need to implement the server'
      visit '/'
      expect(page).to have_content('Rebase Labs!')
    end
  end
end
