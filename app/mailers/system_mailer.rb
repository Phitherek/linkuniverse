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
end
