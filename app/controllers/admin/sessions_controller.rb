class Admin::SessionsController < Admin::BaseController
  skip_before_filter :require_login
  layout 'admin/layouts/dialog'
  
  def new
  end
  
  def create
    user = User.find_by_email(params[:email])
    
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      user.record_login(request, 'admin')

      unless params[:redirect].blank?
        redirect_to params[:redirect]
        return
      end
      
      redirect_to admin_root_path
    else
      flash[:error] = "Invalid email or password"
      redirect_to admin_login_path
    end
  end
  
  def destroy
    session[:user_id] = nil
    redirect_to admin_login_path, notice: "You have been logged out."
  end
  
end
