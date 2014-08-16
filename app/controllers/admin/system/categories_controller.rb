class Admin::System::CategoriesController < Admin::BaseController
  
  def index
    @categories = Category.select("id, name, parent_id, slug, sort, hidden").where(entity_type: params[:type]).order(:sort)
  end

  def new
    @category = Category.new entity_type: params[:type], parent_id: params[:parent_id], name: 'New category'
    
    @category.sort = Category.where(entity_type: params[:type], parent_id: params[:parent_id]).maximum(:sort)
    @category.sort = 0 if @category.sort.nil?
    @category.sort = @category.sort + 1
    
    render 'edit'
  end

  def create
    @category = Category.new(category_params)
    
    if @category.save
      redirect_to action: 'index', type: @category.entity_type, notice: 'Category was successfully created.'
    else
      render 'edit'
    end
  end

  def show
    @category = Category.find(params[:id])
  end

  def edit
    @category = Category.find(params[:id])
  end

  def update
    @category = Category.find(params[:id])
    
    if @category.update(category_params)
      Rails.cache.delete @category
      redirect_to action: 'index', type: @category.entity_type, notice: 'Category was successfully updated.'
    else
      render 'edit'
    end
  end

  def destroy
    @category = Category.find(params[:id])
    
    Rails.cache.delete @category
    @category.destroy
    
    redirect_to action: 'index', type: @category.entity_type, notice: 'Category has been deleted.'
  end
  
  
  private
  
    def category_params
      params.require(:category).permit(:entity_type, :name, :parent_id, :slug, :sort, :hidden, :image_path, :desc1, :desc2, :desc3)
    end
  
end
