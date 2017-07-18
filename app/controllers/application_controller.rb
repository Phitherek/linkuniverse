class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :initialize_breadcrumbs
  include ApplicationHelper

  def render_error type
    if type.to_sym == :forbidden
      render "errors/forbidden", status: 403, layout: 'error' and return
    elsif type.to_sym == :notfound
      render "errors/notfound", status: 404, layout: 'error' and return
    end
  end

  protected

  def initialize_breadcrumbs
    @breadcrumbs = []
  end

  def require_current_user
    if current_user.blank?
      flash[:notice] = 'You have to log in to continue!'
      redirect_to login_users_url
    end
  end
end
