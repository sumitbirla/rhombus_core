class UserMailer < ActionMailer::Base

  default from: "#{Cache.setting(:system, 'From Email Name')} <#{Cache.setting(:system, 'From Email Address')}>"


  def welcome_email(user)
    @user = user
    @url  = Cache.setting('System', 'Website URL')
    @website_name = Cache.setting('System', 'Website Name')

    options = { address: Cache.setting('System', 'SMTP Server') }
    mail(to: @user.email, subject: "Welcome to #{@website_name}", delivery_method_options: options)
  end


  def reset_password_email(user, url)
    @user = user
    @url  = url
    @website_name = Cache.setting('System', 'Website Name')

    options = { address: Cache.setting('System', 'SMTP Server') }
    mail(to: @user.email, subject: 'Password reset instructions', delivery_method_options: options)
  end

end
