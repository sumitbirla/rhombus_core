class Admin::System::AffiliatesController < Admin::BaseController
  
  def index
    authorize Affiliate.new
    
    @affiliates = Affiliate.order(sort_column + " " + sort_direction)
    @affiliates = @affiliates.where("name LIKE '%#{params[:q]}%' OR code = '#{params[:q]}'") unless params[:q].blank?
    
    unless params[:c].blank?
      @category = Category.find_by(slug: params[:c], entity_type: :affiliate)
      @affiliates = @affiliates.joins(:affiliate_categories).where("core_affiliate_categories.category_id = #{@category.id}") 
    end
    
    respond_to do |format|
      format.html { @affiliates = @affiliates.paginate(page: params[:page], per_page: @per_page) }
      format.csv { send_data Affiliate.to_csv(@affiliates) }
    end
  end

  def new
    @affiliate = authorize Affiliate.new(name: 'New affiliate', active: true, country: Cache.setting(:system, "Default Country"))
    render 'edit'
  end

  def create
    @affiliate = authorize Affiliate.new(affiliate_params)
    
    if @affiliate.save
      unless params[:c].blank?
        c = Category.find_by(entity_type: :affiliate, slug: params[:c])
        AffiliateCategory.create(affiliate_id: @affiliate.id, category_id: c.id) unless c.nil?
      end
      redirect_to action: 'show', id: @affiliate.id, notice: 'Affiliate was successfully created.'
    else
      render 'edit'
    end
  end

  def show
    @affiliate = authorize Affiliate.find(params[:id])
  end

  def edit
    @affiliate = authorize Affiliate.find(params[:id])
  end

  def update
    @affiliate = authorize Affiliate.find(params[:id])
    
    if @affiliate.update(affiliate_params)
      redirect_to action: 'show', id: @affiliate.id, notice: 'Affiliate was successfully updated.'
    else
      render 'edit'
    end
  end

  def destroy
    @affiliate = authorize Affiliate.find(params[:id])
    @affiliate.destroy
    
    redirect_to action: 'index', notice: 'Affiliate has been deleted.'
  end
  
  def extra_properties
    @affiliate = Affiliate.find(params[:id])
    authorize @affiliate, :show?
    5.times { @affiliate.extra_properties.build }
  end
  
  def categories
    @affiliate = Affiliate.find(params[:id])
    authorize @affiliate, :show?
  end
  
  def create_categories
    authorize Affiliate, :update?
    
    AffiliateCategory.where(affiliate_id: params[:id]).delete_all
    category_ids = params[:category_ids]
    
    unless category_ids.nil?
      category_ids.each do |id|
        AffiliateCategory.create affiliate_id: params[:id], category_id: id
      end
    end
    
    redirect_to action: 'show', id: params[:id], notice: 'Affiliate was successfully updated.'
  end
  
  def products
    @affiliate = Affiliate.includes(:products, [products: :product]).find(params[:id])
    authorize @affiliate, :show?
  end
  
  def create_products
    authorize Affiliate, :update?
    
    params[:product_ids].each { |id| AffiliateProduct.create product_id: id, affiliate_id: params[:id] }
    redirect_back(fallback_location: admin_root_path)
  end
  
  def remove_products
    authorize Affiliate, :update?
    
    AffiliateProduct.delete_all id: params[:affiliate_product_ids]
    redirect_back(fallback_location: admin_root_path)
  end
  

  private
  
    def affiliate_params
      params.require(:affiliate).permit!
    end
  
    def sort_column
      params[:sort] || "name"
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
    end
end
