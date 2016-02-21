require 'rails_helper'

RSpec.feature 'Track creation', type: :feature do
  let(:user) { FactoryGirl.create :user }
  let!(:admin) { FactoryGirl.create :admin }
  let(:date) { Date.today + 2.years }

  let(:mails) { ActionMailer::Base.deliveries }
  let(:mail) { mails.first }

  scenario 'User creates a new repeating track', :js => true do
    login_as(user, :scope => :user)

    visit '/tracks/new'

    find('#track_name').set 'My Track'
    find(".wday_select").find("option[value='4']", text: 'Freitag').select_option
    4.times { find('.map').click }

    click_button 'Strecke erstellen'

    expect(page).to have_text('Strecke wurde erfolgreich erstellt!')
    expect(page).to have_text('Freitag')
  end

  scenario 'User creates a new track with date', :js => true do
    login_as(user, :scope => :user)

    visit '/tracks/new'

    find('#track_name').set 'My Track'
    find(".bootstrap-switch").click
    parts = %i(day month year).map{|p| date.send(p)}
    parts.each_with_index do |part, i|
      all(".date_select select")[i].find("option[value='#{part}']").select_option
    end


    4.times { find('.map').click }

    Sidekiq::Testing.inline! do
      click_button 'Strecke erstellen'

      expect(page).to have_text('Strecke wurde erfolgreich erstellt!')
      expect(page).to have_text(I18n.l date)
      expect(mails.size).to eq 1
      expect(mail.to).to eq [admin.email]
    end
  end
end
