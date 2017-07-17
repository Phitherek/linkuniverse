class SystemMailer < ActionMailer::Base
  layout 'mailer'

  def activation_email(user)
    @user = user
    mail(to: @user.email, subject: 'Activate your account!')
  end
end
