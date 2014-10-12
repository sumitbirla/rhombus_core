class Admin::System::LoginsController < Admin::BaseController
  
  def index
    @logins = Login.includes(:user).order('timestamp DESC').page(params[:page])
    
    respond_to do |format|
      format.html 
      format.csv { send_data Login.to_csv }
    end
  end
  
end
