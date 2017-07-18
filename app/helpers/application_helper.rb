module ApplicationHelper
  def add_breadcrumb name, url = nil
    if url.nil?
      @breadcrumbs << {name: name}
    else
      @breadcrumbs << {name: name, url: url}
    end
  end

  def current_user
    begin
      User.active.find(session[:logged_in_user_id])
    rescue ActiveRecord::RecordNotFound => e
      nil
    end
  end
end
