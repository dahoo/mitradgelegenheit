class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :add_meta_tags

  def authenticate_admin!
    if current_user
      redirect_to root_path, flash: { error: 'Aktion nicht erlaubt.' } unless current_user.admin?
    else
      redirect_to new_user_session_path, flash: { error: 'Bitte melde dich zuerst an.' }
    end
  end

  def sanitize_filename(filename)
    # Split the name when finding a period which is preceded by some
    # character, and is followed by some character other than a period,
    # if there is no following period that is followed by something
    # other than a period (yeah, confusing, I know)
    fn = filename.split /(?<=.)\.(?=[^.])(?!.*\.[^.])/m

    # We now have one or two parts (depending on whether we could find
    # a suitable period). For each of these parts, replace any unwanted
    # sequence of characters with an underscore
    fn.map! { |s| s.gsub /[^a-z0-9\-]+/i, '_' }

    # Finally, join the parts with a period and return the result
    return fn.join '.'
  end

  def add_meta_tags
    set_meta_tags(
      description: I18n.t(:'meta.description'),
      keywords: ['Fahrrad', 'Rad', 'Mitradgelegenheit', 'Berlin', 'Critical Mass'],
      canonical: 'https://mitradgelegenheit.de',
      og: {
        description: I18n.t(:'meta.description'),
        url: 'https://mitradgelegenheit.de',
        image: 'https://mitradgelegenheit.de/logo.png'
      }
    )
  end
end
