class Admin::System::NotificationsController < Admin::BaseController
  
  def index
    authorize Notification
    @notifications = Notification.order('created_at DESC')
    
    respond_to do |format|
      format.html { @notifications = @notifications.paginate(page: params[:page], per_page: @per_page) }
      format.csv { send_data Notification.to_csv(@notifications) }
    end
  end

  def new
    @notification = authorize Notification.new(title: 'New notification', web_delivery: true)
    render 'edit'
  end

  def create
    @notification = authorize Notification.new(notification_params)
    
    if @notification.save
      redirect_to action: 'index', notice: 'Notification was successfully created.'
    else
      render 'edit'
    end
  end

  def show
    @notification = authorize Notification.find(params[:id])
  end

  def edit
    @notification = authorize Notification.find(params[:id])
  end

  def update
    @notification = authorize Notification.find(params[:id])
    
    if @notification.update(notification_params)
      redirect_to action: 'index', notice: 'Notification was successfully updated.'
    else
      render 'edit'
    end
  end

  def destroy
    @notification = authorize Notification.find(params[:id])
    @notification.destroy
    redirect_to action: 'index', notice: 'Notification has been deleted.'
  end
  
  
  private
  
    def notification_params
      params.require(:notification).permit(:title, :start_time, :expire_time, :user_id, :message, :web_delivery, :sms_delivery, :email_delivery)
    end
  
end
