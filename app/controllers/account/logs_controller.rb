class Account::LogsController < Account::BaseController
  
  def index
    @logs = Log.includes(:user).order(sort_column + " " + sort_direction)
    @logs = @logs.where(loggable_type: params[:type]) unless params[:type].blank?
		@logs = @logs.where(user_id: User.where(affiliate_id: current_user.affiliate_id).pluck(:id))
		@logs = @logs.where(user_id: params[:user_id]) unless params[:user_id].blank?
    
    respond_to do |format|
      format.html { @logs = @logs.paginate(page: params[:page], per_page: @per_page) }
      format.csv { send_data Log.to_csv(@logs) }
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
