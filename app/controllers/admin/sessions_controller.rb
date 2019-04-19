class Admin::SessionsController < Admin::BaseController
  skip_before_action :require_login, raise: false
  layout 'admin/layouts/dialog'
  
  def new
  end
  
  def create
    user = User.find_by_email(params[:email])
    
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      cookies.permanent.signed[:user_id] = user.id if params[:remember_me] == "1"
      
      user.record_login(request, 'admin')
      cookies[:domain_id] = { :value => Domain.first.id, :expires => 1.year.from_now } if cookies[:domain_id].nil?

      unless params[:redirect].blank?
        redirect_to params[:redirect]
        return
      end
      
      redirect_to user.role.landing_page || admin_root_path
    else
      flash[:error] = "Invalid email or password"
      redirect_to admin_login_path
    end
  end
  
  def destroy
    Log.create(user_id: session[:user_id], 
               loggable_type: 'Session', 
               loggable_id: session.id,
               event: 'destroyed', 
               ip_address: request.remote_ip)
               
    reset_session
    cookies.delete :user_id
    
    redirect_to admin_login_path, notice: "You have been logged out."
  end
  
end
