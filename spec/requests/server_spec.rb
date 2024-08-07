require 'spec_helper'

describe 'Testing server' do
  context 'GET /' do
    it 'should return Rebase Labs!' do
      visit '/'
      expect(page).to have_content('Rebase Labs!')
    end
  end

  context 'GET /sum' do
    it 'should return both numbers added' do
      visit '/sum?a=1&b=2'
      expect(page).to have_content('3')
    end
  end
end
