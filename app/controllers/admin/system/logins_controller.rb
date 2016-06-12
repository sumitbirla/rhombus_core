class Admin::System::LoginsController < Admin::BaseController
  
  def index
    @logins = Login.includes(:user).order(sort_column + " " + sort_direction)
    
    respond_to do |format|
      format.html { @logins = @logins.page(params[:page]) }
      format.csv { send_data Login.to_csv(@logins) }
    end
  end
  
  private
  
    def sort_column
      params[:sort] || "timestamp"
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
    end
  
end
