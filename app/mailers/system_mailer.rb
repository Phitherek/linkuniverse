class SystemMailer < ActionMailer::Base
  layout 'mailer'

  def activation_email(user)
    @user = user
    mail(to: @user.email, subject: 'Activate your account!')
  end

  def reset_password_email(user)
    @user = user
    mail(to: @user.email, subject: 'Password reset instructions')
  end

  def ask_for_contact_email(user, current_user)
    @user = user
    @current_user = current_user
    mail(to: @user.email, subject: "Contact request from: #{@current_user.username}")
  end

  def invitation_notification_email(membership)
    @user = membership.user
    @membership = membership
    @current_user = membership.link_collection.user
    mail(to: @user.email, subject: "Invitation to participate in link collection #{@membership.link_collection.name} by user #{@membership.link_collection.user.username}")
  end

  def invitation_accept_notification_email(membership)
    @user = membership.link_collection.user
    @membership = membership
    @current_user = membership.user
    mail(to: @user.email, subject: "#{@current_user.username} has accepted your invitation to participate in link collection #{@membership.link_collection.name}")
  end
end
