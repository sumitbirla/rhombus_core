class Admin::System::DomainsController < Admin::BaseController
  
  def index
    authorize Domain.new
    @domains = Domain.order(:name)
    
    respond_to do |format|
      format.html { @domains = @domains.paginate(page: params[:page], per_page: @per_page) }
      format.csv { send_data Domain.to_csv(@domains) }
    end
  end

  def new
    @domain = authorize Domain.new(name: 'New domain')
    render 'edit'
  end

  def create
    @domain = authorize Domain.new(domain_params)
    
    if @domain.save
      Rails.cache.delete :domains
      redirect_to action: 'index', notice: 'Domain was successfully created.'
    else
      render 'edit'
    end
  end

  def show
    @domain = authorize Domain.find(params[:id])
  end

  def edit
    @domain = authorize Domain.find(params[:id])
  end

  def update
    @domain = authorize Domain.find(params[:id])
    
    if @domain.update(domain_params)
      Rails.cache.delete :domains
      redirect_to action: 'index', notice: 'Domain was successfully updated.'
    else
      render 'edit'
    end
  end

  def destroy
    @domain = authorize Domain.find(params[:id])
    @domain.destroy
    
    Rails.cache.delete :domains
    redirect_to action: 'index', notice: 'Domain has been deleted.'
  end
  
  def set_current
    cookies[:domain_id] = { :value => params[:id], :expires => 1.year.from_now }
    redirect_to :back
  end
  
  
  private
  
    def domain_params
      params.require(:domain).permit!
    end
end
