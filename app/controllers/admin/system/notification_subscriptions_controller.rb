class Admin::System::NotificationSubscriptionsController < Admin::BaseController

  def index
    authorize NotificationSubscription.new
    @notification_subscriptions = NotificationSubscription.order(created_at: :desc)
                                                          .includes(:user, :event_type, [user: :affiliate])
                                                          .paginate(page: params[:page], per_page: @per_page)

    # filter by event_type if parameter specified
    if params[:event_type_id].present?
      @notification_subscriptions = @notification_subscriptions.where(event_type_id: params[:event_type_id])
    end
  end

  def new
    @notification_subscription = authorize NotificationSubscription.new
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
    params.require(:notification_subscription).permit!
  end

end
