require 'rails_helper'

RSpec.feature 'Track editing', type: :feature do
  let(:user) { FactoryGirl.create :user }
  let(:track) { FactoryGirl.create :track, user: user }
  let(:track_with_date) { FactoryGirl.create :track_with_date, user: user }
  let(:date) { Date.today + 2.years }
  before { Capybara.current_session.current_window.resize_to 1200, 1200 }

  scenario 'User changes day of week', :js => true do
    login_as(user, :scope => :user)

    visit "/tracks/#{track.id}/edit"

    find('#track_name').set 'My Track'
    first(".wday_select").find("option[value='4']", text: 'Freitag').select_option

    click_button 'Strecke aktualisieren'

    expect(page).to have_text('Die Strecke wurde erfolgreich aktualisiert.')
    expect(page).to have_text('Freitag')
    expect(page.all('.leaflet-marker-pane .awesome-marker').size).to eq 2
  end

  scenario 'User changes day of week to date', :js => true do
    login_as(user, :scope => :user)

    visit "/tracks/#{track.id}/edit"

    select = first('.wday_select select option[selected]').text
    expect(select).to eq('Dienstag')

    find('#track_name').set 'My Track'
    first(".bootstrap-switch").click
    parts = %i(day month year).map{|p| date.send(p)}
    parts.each_with_index do |part, i|
      all(".date_select select")[i].find("option[value='#{part}']").select_option
    end

    click_button 'Strecke aktualisieren'

    expect(page).to have_text('Die Strecke wurde erfolgreich aktualisiert.')
    expect(page).to have_text(I18n.l date)
    expect(page.all('.leaflet-marker-pane .awesome-marker').size).to eq 2
  end

  scenario 'User changes a date to day of week', :js => true do
    login_as(user, :scope => :user)

    visit "/tracks/#{track_with_date.id}/edit"

    selects = all('.date_select select option[selected]')
    parts = I18n.l(track_with_date.start_times[0].date, format: :long).gsub('.', '').split(' ')
    parts.each_with_index do |part, i|
      expect(selects[i].text).to eq(part.to_s)
    end

    find('#track_name').set 'My Track'
    first(".bootstrap-switch").click
    first(".wday_select").find("option[value='4']", text: 'Freitag').select_option

    click_button 'Strecke aktualisieren'

    expect(page).to have_text('Die Strecke wurde erfolgreich aktualisiert.')
    expect(page).to have_text('Freitag')
    expect(page.all('.leaflet-marker-pane .awesome-marker').size).to eq 2
  end

  scenario 'User adds starts', :js => true do
    login_as(user, :scope => :user)

    visit "/tracks/#{track.id}/edit"

    find('#track_name').set 'My Track'
    first(".leaflet-control-container").find("a[title='Start hinzufügen']").click
    find('.map').click

    click_button 'Strecke aktualisieren'

    expect(page).to have_text('Die Strecke wurde erfolgreich aktualisiert.')
    expect(page.all('.leaflet-marker-pane .awesome-marker').size).to eq 3
  end

  scenario 'User deletes starts', :js => true do
    login_as(user, :scope => :user)

    visit "/tracks/#{track.id}/edit"

    find('#track_name').set 'My Track'
    first(".leaflet-control-container").find("a[title='Start hinzufügen']").click
    find('.map').click
    expect(page.all('.leaflet-marker-pane .awesome-marker').size).to eq 3

    page.all('#starts .remove_fields').last.click

    click_button 'Strecke aktualisieren'

    expect(page).to have_text('Die Strecke wurde erfolgreich aktualisiert.')

    expect(track.starts.size).to eq 1
    expect(track.ends.size).to eq 1
  end
end
