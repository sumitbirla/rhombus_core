class Admin::System::SearchPathsController < Admin::BaseController
  def index
    @search_paths = SearchPath.order(:short_code).all
  end

  def new
    @search_path = SearchPath.new
    render 'edit'
  end

  def create
    @search_path = SearchPath.new(search_path_params)
    
    if @search_path.save
      redirect_to action: 'index'
    else
      render 'edit'
    end
  end

  def edit
    @search_path = SearchPath.find(params[:id])
  end

  def update
    @search_path = SearchPath.find(params[:id])
    
    if @search_path.update(search_path_params)
      redirect_to action: 'index'
    else
      render 'edit'
    end
  end

  def destroy
    SearchPath.destroy(params[:id])
    redirect_to :back
  end
  
  private
  
    def search_path_params
      params.require(:search_path).permit(:short_code, :url, :description)
    end
end
