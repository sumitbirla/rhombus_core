class Admin::System::SettingsController < Admin::BaseController
  
  def index
    @settings = Setting.all.order('section, created_at')
  end

  def new
    @setting = Setting.new section: 'System', key: 'New Key', value_type: 'string'
    render 'edit'
  end

  def create
    @setting = Setting.new(setting_params)
    
    if @setting.save
      redirect_to action: 'index', notice: 'Setting was successfully created.'
    else
      render 'edit'
    end
  end

  def show
    @setting = Setting.find(params[:id])
  end

  def edit
    @setting = Setting.find(params[:id])
  end

  def update
    @setting = Setting.find(params[:id])
    
    if @setting.update(setting_params)
      Rails.cache.delete @setting
      redirect_to action: 'index', notice: 'Setting was successfully updated.'
    else
      render 'edit'
    end
  end

  def destroy
    @setting = Setting.find(params[:id])
    @setting.destroy
    
    Rails.cache.delete @setting
    redirect_to action: 'index', notice: 'Setting has been deleted.'
  end
  
  
  private
  
    def setting_params
      params.require(:setting).permit(:section, :key, :value, :value_type, :description)
    end
  
end
