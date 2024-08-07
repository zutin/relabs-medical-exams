require 'spec_helper'

describe 'Testing server' do
  context 'when GET /' do
    it 'returns Rebase Labs!' do
      visit '/'
      expect(page).to have_content('Rebase Labs!')
    end
  end

  context 'when GET /sum' do
    it 'returns both numbers added' do
      visit '/sum?a=1&b=2'
      expect(page).to have_content('3')
    end
  end
end
