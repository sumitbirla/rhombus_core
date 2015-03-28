class UserMailer < ActionMailer::Base

  default from: "#{Cache.setting(Rails.configuration.domain_id, :system, 'From Email Name')} <#{Cache.setting(Rails.configuration.domain_id, :system, 'From Email Address')}>"


  def welcome_email(user)
    @user = user
    
    @website_name = Cache.setting(user.domain_id, :system, 'Website Name')
    @website_url = Cache.setting(user.domain_id, :system, 'Website URL')
    
    from_name = Cache.setting(user.domain_id, :system, 'From Email Name')
    from_email = Cache.setting(user.domain_id, :system, 'From Email Address')

    options = { address: Cache.setting(user.domain_id, :system, 'SMTP Server') }
    mail(from: "#{from_name} <#{from_email}>",
         to: @user.email, 
         subject: "Welcome to #{@website_name}", 
         delivery_method_options: options)
  end


  def reset_password_email(user, url)
    @user = user
    @reset_url  = url
    from_name = Cache.setting(user.domain_id, :system, 'From Email Name')
    from_email = Cache.setting(user.domain_id, :system, 'From Email Address')

    options = { address: Cache.setting(user.domain_id, :system, 'SMTP Server') }
    mail( from: "#{from_name} <#{from_email}>",
          to: @user.email, 
          subject: 'Password reset instructions', 
          delivery_method_options: options)
  end

end
