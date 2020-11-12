class Admin::System::NotificationSubscriptionsController < Admin::BaseController

  def index
    authorize NotificationSubscription.new
    @notification_subscriptions = NotificationSubscription.order(created_at: :desc)
                                                          .include(:user, :event_type, :notification_delivery_method)
  end

  def new
    @notification_subscription = authorize NotificationSubscription.new(title: 'New notification_subscription', web_delivery: true)
    render 'edit'
  end

  def create
    @notification_subscription = authorize NotificationSubscription.new(notification_subscription_params)

    if @notification_subscription.save
      redirect_to action: 'index', notice: 'Notification was successfully created.'
    else
      render 'edit'
    end
  end

  def show
    @notification_subscription = authorize NotificationSubscription.find(params[:id])
  end

  def edit
    @notification_subscription = authorize NotificationSubscription.find(params[:id])
  end

  def update
    @notification_subscription = authorize NotificationSubscription.find(params[:id])

    if @notification_subscription.update(notification_subscription_params)
      redirect_to action: 'index', notice: 'Notification was successfully updated.'
    else
      render 'edit'
    end
  end

  def destroy
    @notification_subscription = authorize NotificationSubscription.find(params[:id])
    @notification_subscription.destroy
    redirect_to action: 'index', notice: 'Notification has been deleted.'
  end


  private

  def notification_subscription_params
    params.require(:notification_subscription).permit(:title, :start_time, :expire_time, :user_id, :message, :web_delivery, :sms_delivery, :email_delivery)
  end

end
