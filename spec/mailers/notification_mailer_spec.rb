require 'rails_helper'

RSpec.describe NotificationMailer, type: :mailer do
  let!(:admin) { FactoryGirl.create :admin }
  let(:track) { FactoryGirl.create :track }

  describe 'new_track' do
    let(:mail) { NotificationMailer.new_track(track, admin) }

    it 'renders the headers' do
      expect(mail.subject).to eq('Neue Strecke eingetragen')
      expect(mail.to).to eq([admin.email])
      expect(mail.from).to eq(['info@mitradgelegenheit.de'])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to include(track.name)
    end
  end

  describe 'new_comment' do
    let!(:user) { track.user }
    let!(:comment) { FactoryGirl.create :comment, track: track, user: user }

    let(:mail) { NotificationMailer.new_comment(comment, user) }

    it 'renders the headers' do
      expect(mail.subject).to eq('Neuer Kommentar zu ' + track.name)
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(['info@mitradgelegenheit.de'])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to include(comment.text)
    end
  end
end
