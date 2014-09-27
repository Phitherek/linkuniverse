class UsersController < ApplicationController
    def login
        if request.get?
            if !current_user.nil?
                redirect_to root_path and return
            end
        elsif request.post?
            @user = User.find_by_email(params[:email])
            if !@user.nil?
                if @user.password_matches?(params[:password])
                    session[:logged_in_user_id] = @user.id
                    flash[:notice] = "Login successful!"
                    redirect_to root_path and return
                else
                    flash[:error] = "Login failed!"
                end
            else
                flash[:error] = "Login failed!"
            end
            render :login
        end
    end
    
    def logout
        session.delete(:logged_in_user_id)
        redirect_to root_path
    end
    
    def register
        @user = User.new
        if request.post?
            password = params[:user].delete(:password)
            password_confirmation = params[:user].delete(:password_confirmation)
            if password && password_confirmation && !password.empty? && !password_confirmation.empty?
                if password == password_confirmation
                    @user.attributes = user_params
                    begin
                        @user.store_password!(password)
                        flash[:notice] = "Registration successfull!"
                        redirect_to login_users_path and return
                    rescue Exception => e
                        error_msg = e.to_s
                    end
                else
                    error_msg = "Password and confirmation do not match!"
                end
            else
                error_msg = "Password and password confirmation are required!"
            end
            if error_msg
                flash[:error] = error_msg
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
        params.require(:user).permit(:username, :email, :description)
    end
end
