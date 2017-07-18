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
end
