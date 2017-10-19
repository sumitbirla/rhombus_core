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
    @notification = Notification.new(title: 'New notification', web_delivery: true)
    authorize @notification
    render 'edit'
  end

  def create
    @notification = Notification.new(notification_params)
    authorize @notification
    
    if @notification.save
      redirect_to action: 'index', notice: 'Notification was successfully created.'
    else
      render 'edit'
    end
  end

  def show
    @notification = Notification.find(params[:id])
    authorize @notification
  end

  def edit
    @notification = Notification.find(params[:id])
    authorize @notification
  end

  def update
    @notification = Notification.find(params[:id])
    authorize @notification
    
    if @notification.update(notification_params)
      redirect_to action: 'index', notice: 'Notification was successfully updated.'
    else
      render 'edit'
    end
  end

  def destroy
    @notification = Notification.find(params[:id])
    authorize @notification
    @notification.destroy
    redirect_to action: 'index', notice: 'Notification has been deleted.'
  end
  
  
  private
  
    def notification_params
      params.require(:notification).permit(:title, :start_time, :expire_time, :user_id, :message, :web_delivery, :sms_delivery, :email_delivery)
    end
  
end
