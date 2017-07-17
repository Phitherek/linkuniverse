class UsersController < ApplicationController

  before_action :find_user, except: [:login, :logout, :register, :me, :edit_me, :update_me, :destroy_me, :do_destroy_me, :accept_membership, :cancel_membership, :activate, :start_password_reset, :do_start_password_reset, :resend_activation_email, :do_resend_activation_email]
  before_action :require_current_user, except: [:register, :login, :show, :activate, :start_password_reset, :do_start_password_reset, :resend_activation_email, :do_resend_activation_email]

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
        flash[:notice] = "Registration successful! Activation e-mail has been sent to #{@user.email}!"
        redirect_to root_path and return
      else flash[:error] = "Could not register: " + @user.errors.full_messages.join(", ") + "!"
      end
      render :register
    end
  end

  def show
    add_breadcrumb 'Home', root_path
    add_breadcrumb 'Users'
    add_breadcrumb @user.username
    @latest_collections = @user.collections.toplevel.to_a.select { |c| c.permission_for(current_user).present? }.sort { |c1, c2| c2.updated_at <=> c1.updated_at }.first(9)
  end

  def me
    add_breadcrumb 'Home', root_path
    add_breadcrumb 'Your profile'
    @pending_memberships = current_user.link_collection_memberships.inactive
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
      redirect_to edit_me_users_path
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

  def accept_membership
    begin
      @membership = current_user.link_collection_memberships.inactive.find(params[:membership_id])
      @membership.active = true
      if @membership.save
        flash[:notice] = 'Invitation to participate in link collection accepted successfully!'
      else
        flash[:error] = "Could not accept invitation to participate in link collection: #{@membership.errors.full_messages.join(',')}!"
      end
    rescue ActiveRecord::RecordNotFound
      flash[:error] = 'Could not find invitation to participate in link collection!'
    end
    redirect_to me_users_path
  end

  def cancel_membership
    begin
      @membership = current_user.link_collection_memberships.inactive.find(params[:membership_id])
      if @membership.destroy
        flash[:notice] = 'Invitation to participate in link collection rejected successfully!'
      else
        flash[:error] = 'Could not reject invitation to participate in link collection!'
      end
    rescue ActiveRecord::RecordNotFound
      flash[:error] = 'Could not find invitation to participate in link collection!'
    end
    redirect_to me_users_path
  end

  def activate
    if current_user.present?
      flash[:notice] = 'You are already logged in!'
      redirect_to root_url and return
    end
    @user = User.inactive.find_by_activation_token(params[:activation_token])
    if @user.present?
      @user.active = true
      if @user.save
        flash[:notice] = 'Account activated successfully!'
        redirect_to login_users_url
      else
        flash[:error] = "Could not activate account: #{@user.errors.full_messages.join(', ')}!"
        redirect_to root_url
      end
    else
      flash[:error] = 'Invalid token!'
      redirect_to root_url
    end
  end

  def start_password_reset

  end

  def do_start_password_reset

  end

  def reset_password

  end

  def do_reset_password

  end

  def resend_activation_email

  end

  def do_resend_activation_email

  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :description, :password, :password_confirmation)
  end

  def find_user
      @user = User.find_by_username(params[:id])
      render_error :notfound if @user.blank?
  end
end
