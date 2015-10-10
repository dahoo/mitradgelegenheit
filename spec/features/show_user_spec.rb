require 'rails_helper'

RSpec.feature 'Show user', type: :feature do
  let(:user) { FactoryGirl.create :user }
  let(:user_2) { FactoryGirl.create :user_2 }
  let!(:track) { FactoryGirl.create :track, user: user, name: 'Track 1' }
  let!(:track_2) { FactoryGirl.create :track, user: user_2, name: 'Track 2' }
  before { page.driver.block_unknown_urls }

  context 'as user' do
    before { login_as(user, :scope => :user) }

    scenario 'User views other profile', :js => true do
      visit "/users/#{user_2.id}"

      expect(page).to have_text(track_2.name)
      expect(page).to have_text(user_2.name)
    end

    scenario 'User views own track', :js => true do
      visit "/users/#{user.id}"

      expect(page).to have_text(track.name)
      expect(page).to have_text('Meine')
    end
  end
end
