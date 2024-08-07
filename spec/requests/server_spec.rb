require 'spec_helper'
require 'database'

RSpec.describe 'Testing server' do
  describe 'GET /' do
    it 'returns Rebase Labs!' do
      visit '/'
      expect(page).to have_content('Rebase Labs!')
    end
  end
end
