class NotificationMailer < ActionMailer::Base
  default from: 'MitRADgelegenheit <info@mitradgelegenheit.de>'
  layout 'mailer'

  def new_track(track, admin)
    @track = track
    mail(to: admin.email)
  end

  def send_new_track(track)
    admins = User.admin.reject{|admin| admin == track.user }
    admins.each do |admin|
      NotificationMailer.delay.new_track(track, admin)
    end
  end
end
