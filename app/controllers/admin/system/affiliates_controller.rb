class Admin::System::AffiliatesController < Admin::BaseController
  def index
    @affiliates = Affiliate.order('created_at DESC')
    @affiliates = @affiliates.where("name LIKE '%#{params[:q]}%' OR code = '#{params[:q]}'") unless params[:q].blank?
    
    unless params[:c].blank?
      @category = Category.find_by(slug: params[:c], entity_type: :affiliate)
      @affiliates = @affiliates.joins(:affiliate_categories).where("core_affiliate_categories.category_id = #{@category.id}") 
    end
    
    respond_to do |format|
      format.html { @affiliates = @affiliates.page(params[:page]) }
      format.csv { send_data @affiliates.to_csv }
    end
  end

  def new
    @affiliate = Affiliate.new name: 'New affiliate'
    render 'edit'
  end

  def create
    @affiliate = Affiliate.new(affiliate_params)
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
    @affiliate = Affiliate.find(params[:id])
  end

  def edit
    @affiliate = Affiliate.find(params[:id])
  end

  def update
    @affiliate = Affiliate.find(params[:id])
    if @affiliate.update(affiliate_params)
      redirect_to action: 'show', id: @affiliate.id, notice: 'Affiliate was successfully updated.'
    else
      render 'edit'
    end
  end

  def destroy
    @affiliate = Affiliate.find(params[:id])
    @affiliate.destroy
    redirect_to action: 'index', notice: 'Affiliate has been deleted.'
  end
  
  def categories
    @affiliate = Affiliate.find(params[:id])
  end
  
  def create_categories
    AffiliateCategory.delete_all affiliate_id: params[:id]
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
  end
  
  def create_products
    params[:product_ids].each { |id| AffiliateProduct.create product_id: id, affiliate_id: params[:id] }
    redirect_to :back
  end
  
  def remove_products
    AffiliateProduct.delete_all id: params[:affiliate_product_ids]
    redirect_to :back
  end
  

  private
  
  def affiliate_params
    params.require(:affiliate).permit!
  end
end
