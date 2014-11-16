require 'rails_helper'

RSpec.describe StaticController, :type => :controller do
  describe 'about' do
    it 'should be success' do
      get 'about'
      expect(response).to be_success
    end
  end
end
