class Admin::System::SearchPathsController < Admin::BaseController
  def index
    authorize SearchPath.new
    @search_paths = SearchPath.order(:short_code).all
  end

  def new
    @search_path = authorize SearchPath.new
    render 'edit'
  end

  def create
    @search_path = authorize SearchPath.new(search_path_params)
    
    if @search_path.save
      redirect_to action: 'index'
    else
      render 'edit'
    end
  end

  def edit
    @search_path = authorize SearchPath.find(params[:id])
  end

  def update
    @search_path = authorize SearchPath.find(params[:id])
    
    if @search_path.update(search_path_params)
      redirect_to action: 'index'
    else
      render 'edit'
    end
  end

  def destroy
    @search_path = authorize SearchPath.find(params[:id])
    @search_path.destroy
    redirect_to :back
  end
  
  private
  
    def search_path_params
      params.require(:search_path).permit(:short_code, :url, :description)
    end
end
