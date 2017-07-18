class UsersController < ApplicationController

  before_action :find_user, except: [:login, :logout, :register, :me, :edit_me, :update_me, :destroy_me, :do_destroy_me, :accept_membership, :cancel_membership, :activate, :start_password_reset, :do_start_password_reset, :resend_activation_email, :do_resend_activation_email, :reset_password, :do_reset_password]
  before_action :require_current_user, except: [:register, :login, :show, :activate, :start_password_reset, :do_start_password_reset, :resend_activation_email, :do_resend_activation_email, :reset_password, :do_reset_password]

  def login
    add_breadcrumb 'Home', root_path
    add_breadcrumb 'Login'
    if request.get?
      unless current_user.nil?
        redirect_to root_url and return
      end
    elsif request.post?
      @user = User.find_by_username_or_email(params[:key]).try(:authenticate, params[:password])
      if !@user.nil? && @user.active?
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
        if @membership.link_collection.user.invitation_accept_notification_enabled
          SystemMailer.invitation_accept_notification_email(@membership).deliver
        end
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
    add_breadcrumb 'Home', root_path
    add_breadcrumb 'Reset password'
    if current_user.present?
      flash[:notice] = 'You are already logged in!'
      redirect_to root_url
    end
  end

  def do_start_password_reset
    if current_user.present?
      flash[:notice] = 'You are already logged in!'
      redirect_to root_url and return
    end
    @user = User.active.find_by_username(params[:username])
    if @user.present? && @user.start_password_reset
      SystemMailer.reset_password_email(@user).deliver
    end
    flash[:notice] = 'If the user exists and is active the reset password email has been sent to its email address!'
    redirect_to login_users_url
  end

  def reset_password
    add_breadcrumb 'Home', root_path
    add_breadcrumb 'Reset password'
    if current_user.present?
      flash[:notice] = 'You are already logged in!'
      redirect_to root_url and return
    end
    @user = User.active.find_by(password_reset_used: false, password_reset_token: params[:password_reset_token])
    if @user.blank?
      flash[:error] = 'Bad token!'
      redirect_to root_url
    end
  end

  def do_reset_password
    if current_user.present?
      flash[:notice] = 'You are already logged in!'
      redirect_to root_url and return
    end
    @user = User.active.find_by(password_reset_used: false, password_reset_token: params[:password_reset_token])
    if @user.blank?
      flash[:error] = 'Bad token!'
      redirect_to root_url
    end
    if @user.update(password: params[:password], password_confirmation: params[:password_confirmation], password_reset_used: true)
      flash[:notice] = 'Password reset successful!'
      redirect_to login_users_url
    else
      flash[:error] = "Password reset failed: #{@user.errors.full_messages.join(',')}"
      redirect_to reset_password_users_url(password_reset_token: @user.password_reset_token)
    end
  end

  def resend_activation_email
    add_breadcrumb 'Home', root_path
    add_breadcrumb 'Resend activation email'
    if current_user.present?
      flash[:notice] = 'You are already logged in!'
      redirect_to root_url
    end
  end

  def do_resend_activation_email
    if current_user.present?
      flash[:notice] = 'You are already logged in!'
      redirect_to root_url and return
    end
    @user = User.inactive.find_by_username(params[:username])
    if @user.present?
      @user.generate_activation_token if @user.activation_token.blank?
      @user.save
      @user.send_activation_email
    end
    flash[:notice] = 'If the user exists and has not yet been activated the activation email has been sent to its email address!'
    redirect_to root_url
  end

  def ask_for_contact
    SystemMailer.ask_for_contact_email(@user, current_user).deliver
    flash[:notice] = 'Contact request sent!'
    redirect_to user_url(@user.username)
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :description, :password, :password_confirmation, :invitation_notification_enabled, :invitation_accept_notification_enabled)
  end

  def find_user
    @user = User.active.find_by_username(params[:id])
    render_error :notfound if @user.blank?
  end
end
