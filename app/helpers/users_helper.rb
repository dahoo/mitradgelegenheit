module UsersHelper
  def current?(user)
    user.id == current_user.id if current_user
  end
end
