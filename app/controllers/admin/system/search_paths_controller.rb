class Admin::System::SearchPathsController < Admin::BaseController
  def index
    authorize SearchPath
    @search_paths = SearchPath.order(:short_code).all
  end

  def new
    @search_path = SearchPath.new
    authorize @search_path
    
    render 'edit'
  end

  def create
    @search_path = SearchPath.new(search_path_params)
    authorize @search_path
    
    if @search_path.save
      redirect_to action: 'index'
    else
      render 'edit'
    end
  end

  def edit
    @search_path = SearchPath.find(params[:id])
    authorize @search_path
  end

  def update
    @search_path = SearchPath.find(params[:id])
    authorize @search_path
    
    if @search_path.update(search_path_params)
      redirect_to action: 'index'
    else
      render 'edit'
    end
  end

  def destroy
    SearchPath.destroy(params[:id])
    authorize @search_path
    
    redirect_to :back
  end
  
  private
  
    def search_path_params
      params.require(:search_path).permit(:short_code, :url, :description)
    end
end
