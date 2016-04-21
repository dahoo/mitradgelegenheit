require 'rails_helper'

RSpec.feature 'Show track', type: :feature do
  let!(:user) { FactoryGirl.create :user }
  let!(:user_2) { FactoryGirl.create :user_2 }
  let!(:admin) { FactoryGirl.create :admin }
  let!(:track) { FactoryGirl.create :track, user: user }
  let!(:other_comment) { FactoryGirl.create :comment, track: track, user: user_2 }

  let(:mails) { ActionMailer::Base.deliveries }
  let(:mail) { mails.first }

  context 'as user' do
    let(:comment_text) { 'This is a comment.' }
    before { login_as(user, :scope => :user) }

    scenario 'User comments on track', :js => true do
      visit "/tracks/#{track.id}"

      find('#comment_text').set comment_text

      Sidekiq::Testing.inline! do
        click_button 'Kommentieren'

        expect(page).to have_text('Kommentar wurde erfolgreich erstellt.')
        expect(page).to have_text(user.name)
        expect(page).to have_text(comment_text)
        expect(mails.size).to eq 2
        expect(mails.map(&:to).flatten).to match_array [admin.email, user_2.email]
      end
    end
  end

  context 'as admin' do
    before { login_as(admin, :scope => :user) }

    let!(:comment) { FactoryGirl.create :comment, user: user, track: track }

    let(:comment_text) { 'This is a comment.' }
    before { login_as(user, :scope => :user) }

    scenario 'Admin deletes track', :js => true do
      visit "/tracks/#{track.id}"

      find('#comment_text').set comment_text
      click_button 'Kommentieren'

      expect(page).to have_text(user.name)
      expect(page).to have_text(comment_text)
    end
  end
end
