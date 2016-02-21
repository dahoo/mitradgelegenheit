require 'rails_helper'

RSpec.feature 'Show track', type: :feature do
  let(:user) { FactoryGirl.create :user }
  let(:admin) { FactoryGirl.create :admin }
  let(:track) { FactoryGirl.create :track, user: user }
  let(:track_2) { FactoryGirl.create :track, :other_user }

  context 'as user' do
    before { login_as(user, :scope => :user) }

    scenario 'User views own track', :js => true do
      visit "/tracks/#{track.id}"

      expect(page).to have_text(track.name)
      expect(page).to have_link(user.name, href: user_path(user))

      expect(page).to have_link('Ändern')
      expect(page).to have_link('Löschen')
    end

    scenario 'User views other track', :js => true do
      visit "/tracks/#{track_2.id}"

      expect(page).to have_text(track_2.name)
      expect(page).to have_link(track_2.user.name, href: user_path(track_2.user))

      expect(page).not_to have_link('Ändern')
      expect(page).not_to have_link('Löschen')
    end
  end

  context 'as admin' do
    before { login_as(admin, :scope => :user) }

    scenario 'User views other track', :js => true do
      visit "/tracks/#{track.id}"

      expect(page).to have_text(track.name)
      expect(page).to have_link(track.user.name, href: user_path(track.user))

      expect(page).to have_link('Ändern')
      expect(page).to have_link('Löschen')
    end
  end
end
