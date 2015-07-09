module ApplicationHelper
  def javascript(*files)
    content_for(:head) { javascript_include_tag(*files) }
  end

  def bootstrap_class_for flash_type
    { success: "alert-success", error: "alert-danger", alert: "alert-warning", notice: "alert-info" }[flash_type] || flash_type.to_s
  end

  def flash_messages(opts = {})
    flash.each do |msg_type, message|
      concat(content_tag(:div, message, class: "alert #{bootstrap_class_for(msg_type.to_sym)} fade in") do
          concat content_tag(:button, 'x', class: "close", data: { dismiss: 'alert' })
        concat message
      end)
    end
    nil
  end

  def title(page_title)
    content_for(:title) { page_title }
  end

  def current_user_id
    current_user.id if current_user
  end

  def admin_signed_in?
    current_user && current_user.admin?
  end
end
