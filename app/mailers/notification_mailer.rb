class NotificationMailer < ActionMailer::Base
  default from: 'mitRADgelegenheit <info@mitradgelegenheit.de>'
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

  def new_comment(comment, user)
    @comment = comment
    mail(
      to: user.email,
      subject: default_i18n_subject(track_name: comment.track.name)
    )
  end

  def send_new_comment(comment)
    users = User.admin.select do |admin|
      admin != comment.track.user && admin.settings(:email).admin_new_comment
    end
    users << comment.track.user if comment.track.user.settings(:email).new_comment
    users += comment.track.comments.map(&:user)
    users.delete(comment.user)
    users.uniq.each do |user|
      NotificationMailer.delay.new_comment(comment, user)
    end
  end
end
