class UsersController < ApplicationController
    
    before_filter :find_user, except: [:login, :logout, :register]
    
    def login
        if request.get?
            unless current_user.nil?
                redirect_to root_path and return
            end
        elsif request.post?
            @user = User.find_by_username_or_email(params[:key]).try(:authenticate, params[:password])
            if !@user.nil?
                session[:logged_in_user_id] = @user.id
                flash[:notice] = "Login successful!"
                redirect_to root_path and return
            else
                flash[:error] = "Login failed!"
            end
            render :login
        end
    end
    
    def logout
        session.delete(:logged_in_user_id)
        flash[:notice] = "Logout successful!"
        redirect_to root_path
    end
    
    def register
        @user = User.new
        if request.post?
            @user.attributes = user_params
            if @user.save
                flash[:notice] = "Registration successful!"
                redirect_to root_path and return
            else
                flash[:error] = "Could not register: " + @user.errors.full_messages.join(", ") + "!"
            end
            render :register
        end
    end
    
    def show
    end
    
    def edit
        
    end
    
    def update
        
    end
    
    private
    
    def user_params
        params.require(:user).permit(:username, :email, :description, :password, :password_confirmation)
    end
    
    def find_user
        begin
            @user = User.find(params[:id])
        rescue ActiveRecord::RecordNotFound => e
            render_error :notfound
        end
    end
    
    def ensure_owner
        if @user != current_user
            render_error :forbidden
        end
    end
end
