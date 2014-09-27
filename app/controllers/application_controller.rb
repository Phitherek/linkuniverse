class ApplicationController < ActionController::Base
    # Prevent CSRF attacks by raising an exception.
    # For APIs, you may want to use :null_session instead.
    protect_from_forgery with: :exception
    
    def current_user
        begin
            User.find(session[:logged_in_user_id])
        rescue ActiveRecord::RecordNotFound => e
            nil
        end
    end
    
    def render_error type
        if type.to_sym == :forbidden
            render "errors/forbidden", status: 403, layout: :error and return
        elsif type.to_sym == :notfound
            render "errors/notfound", status: 404, layout: :error and return
        end
    end
end
