class UsersController < ApplicationController

  before_filter :find_user, except: [:login, :logout, :register, :me, :edit_me, :update_me, :destroy_me, :do_destroy_me]
  before_filter :ensure_owner, only: [:edit, :update]

  def login
    add_breadcrumb 'Home', root_path
    add_breadcrumb 'Login'
    if request.get?
      unless current_user.nil?
        redirect_to root_url and return
      end
    elsif request.post?
      @user = User.find_by_username_or_email(params[:key]).try(:authenticate, params[:password])
      if !@user.nil?
        session[:logged_in_user_id] = @user.id
        flash[:notice] = "Login successful!"
        redirect_to root_url and return
      else flash[:error] = "Login failed!"
      end
      render :login
    end
  end

  def logout
    session.delete(:logged_in_user_id)
    flash[:notice] = "Logout successful!"
    redirect_to root_url
  end

  def register
    add_breadcrumb 'Home', root_path
    add_breadcrumb 'Register'
    @user = User.new
    if request.post?
      @user.attributes = user_params
      if @user.save
        flash[:notice] = "Registration successful!"
        redirect_to root_path and return
      else flash[:error] = "Could not register: " + @user.errors.full_messages.join(", ") + "!"
      end
      render :register
    end
  end

  def show
  end

  def me
    add_breadcrumb 'Home', root_path
    add_breadcrumb 'Your profile'
  end

  def edit_me
    add_breadcrumb 'Home', root_path
    add_breadcrumb 'Your profile', me_users_path
    add_breadcrumb 'Edit'
  end

  def update_me
    u = current_user
    if u.authenticate(params[:user][:current_password])
      if params[:user][:password].blank?
        params[:user].delete(:password)
        params[:user].delete(:password_confirmation)
      end
      if u.try(:update, user_params)
        flash[:notice] = 'Your profile updated successfully!'
        redirect_to me_users_url
      else
        flash[:error] = "Could not update your profile: #{u.errors.full_messages.join(', ')}!"
        redirect_to edit_me_users_path and return
      end
    else
      flash[:error] = 'Could not update your profile: Invalid current password!'
      redirect_to edit_me_users_path and return
    end
  end

  def destroy_me
    add_breadcrumb 'Home', root_path
    add_breadcrumb 'Your profile', me_users_path
    add_breadcrumb 'Delete'
  end

  def do_destroy_me
    if current_user.destroy
      session.delete(:logged_in_user_id)
      flash[:notice] = 'Your profile deleted successfully!'
    else
      flash[:error] = 'Could not delete your profile!'
    end
    redirect_to root_url
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
