require 'rails_helper'

RSpec.feature 'Show users', type: :feature do
  let(:admin) { FactoryGirl.create :admin }
  let(:user) { FactoryGirl.create :user }
  let(:user_2) { FactoryGirl.create :user_2 }
  let!(:track) { FactoryGirl.create :track, user: user, name: 'Track 1' }
  let!(:track_2) { FactoryGirl.create :track, user: user_2, name: 'Track 2' }

  context 'as admin' do
    before { login_as(admin, :scope => :user) }

    scenario 'Admin views users', :js => true do
      visit "/users"

      expect(page).to have_link(user.name)
      expect(page).to have_link(user_2.name)
    end
  end

  context 'as user' do
    before { login_as(user, :scope => :user) }

    scenario 'User views users', :js => true do
      visit "/users"

      expect(page).to have_text('Aktion nicht erlaubt')
    end
  end
end
