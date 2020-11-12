class Admin::System::EventTypesController < Admin::BaseController

  def index
    authorize EventType.new
    @event_types = EventType.order(:name)
                            .paginate(page: params[:page], per_page: @per_page)
  end

  def new
    @event_type = authorize EventType.new
    render 'edit'
  end

  def create
    @event_type = authorize EventType.new(event_type_params)

    if @event_type.save
      redirect_to action: 'index', notice: 'Event Type was successfully created.'
    else
      render 'edit'
    end
  end

  def show
    @event_type = authorize EventType.find(params[:id])
  end

  def edit
    @event_type = authorize EventType.find(params[:id])
  end

  def update
    @event_type = authorize EventType.find(params[:id])

    if @event_type.update(event_type_params)
      redirect_to action: 'index', notice: 'Event Type was successfully updated.'
    else
      render 'edit'
    end
  end

  def destroy
    @event_type = authorize EventType.find(params[:id])
    @event_type.destroy
    redirect_to action: 'index', notice: 'Event Type has been deleted.'
  end


  private

  def event_type_params
    params.require(:event_type).permit!
  end

end
