class UserMailer < ActionMailer::Base

  default from: "#{Cache.setting(Rails.configuration.domain_id, :system, 'From Email Name')} <#{Cache.setting(Rails.configuration.domain_id, :system, 'From Email Address')}>"


  def welcome_email(user_id)
    @user = User.find(user_id)
    
    @website_name = Cache.setting(@user.domain_id, :system, 'Website Name')
    @website_url = Cache.setting(@user.domain_id, :system, 'Website URL')
    
    from_name = Cache.setting(@user.domain_id, :system, 'From Email Name')
    from_email = Cache.setting(@user.domain_id, :system, 'From Email Address')
    subject = Cache.setting(@user.domain_id, :system, 'Welcome Email Subject') || "Welcome to #{@website_name}"

    mail(from: "#{from_name} <#{from_email}>",
         to: @user.email, 
         subject: subject)
  end


  def reset_password_email(user, url)
    @user = user
    @reset_url  = url
    from_name = Cache.setting(user.domain_id, :system, 'From Email Name')
    from_email = Cache.setting(user.domain_id, :system, 'From Email Address')

    mail( from: "#{from_name} <#{from_email}>",
          to: @user.email, 
          subject: 'Password reset instructions')
  end

end
