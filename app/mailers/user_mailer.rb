class UserMailer < ActionMailer::Base

  default from: "#{Cache.setting(Rails.configuration.domain_id, :system, 'From Email Name')} <#{Cache.setting(Rails.configuration.domain_id, :system, 'From Email Address')}>"


  def welcome_email(user)
    @user = user

    options = { address: Cache.setting(user.domain_id, :system, 'SMTP Server') }
    mail(to: @user.email, subject: "Welcome to #{@website_name}", delivery_method_options: options)
  end


  def reset_password_email(user, url)
    @user = user
    @reset_url  = url

    options = { address: Cache.setting(user.domain_id, :system, 'SMTP Server') }
    mail(to: @user.email, subject: 'Password reset instructions', delivery_method_options: options)
  end

end
