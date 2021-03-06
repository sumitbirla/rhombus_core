class Admin::System::EventsController < Admin::BaseController
  def index
    authorize Event.new
    @events = Event.includes(:event_type)
                   .order(created_at: :desc)
                   .paginate(page: params[:page], per_page: @per_page)
  end

  def new
    @event = authorize Event.new
    render 'edit'
  end

  def create
    @event = authorize Event.new(event_params)

    if @event.save
      redirect_to action: 'index', notice: 'Event was successfully created.'
    else
      render 'edit'
    end
  end

  def show
    @event = authorize Event.find(params[:id])
  end

  def edit
    @event = authorize Event.find(params[:id])
  end

  def update
    @event = authorize Event.find(params[:id])

    if @event.update(event_params)
      redirect_to action: 'index', notice: 'Event was successfully updated.'
    else
      render 'edit'
    end
  end

  def destroy
    @event = authorize Event.find(params[:id])
    @event.destroy
    redirect_to action: 'index', notice: 'Event has been deleted.'
  end

  def resend
    @event = Event.find(params[:id])
    @event.update_column(:processed_at, nil)
    flash[:info] = "Event has been re-dispatched."
    redirect_back(fallback_location: admin_system_events_path)
  end

  private

  def event_params
    params.require(:event).permit!
  end
end
