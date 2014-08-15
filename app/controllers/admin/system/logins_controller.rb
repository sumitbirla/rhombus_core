class Admin::System::LoginsController < Admin::BaseController
  
  def index
    @logins = Login.includes(:user).page(params[:page]).order('timestamp DESC')
  end
  
end
