class Admin::System::RolesController < Admin::BaseController
  
  def index
    authorize Role.new
    @roles = Role.order(:name)
    
    respond_to do |format|
      format.html { @roles = @roles.paginate(page: params[:page], per_page: @per_page) }
      format.csv { send_data Role.to_csv(@roles) }
    end
  end

  def new
    @role = authorize Role.new
    render 'edit'
  end

  def create
    @role = authorize Role.new(role_params)
    
    if @role.save
      
      # Save permissions
      unless params[:permission_ids].nil?
        params[:permission_ids].each do |id|
          RolePermission.create role_id: @role.id, permission_id: id
        end
      end
      
      # Un-default other roles if necessary
      if @role.default
        Role.where.not(id: @role.id).update_all(default: false)
      end
      
      redirect_to action: 'index', notice: 'Role was successfully created.'
    else
      render 'edit'
    end
  end

  def show
    @role = authorize Role.find(params[:id])
  end

  def edit
    @role = authorize Role.find(params[:id])
  end

  def update
    @role = authorize Role.find(params[:id])
    
    if @role.update(role_params)
      
      # Update permissions
      RolePermission.delete_all role_id: @role.id
      params[:permission_ids].each do |id|
        RolePermission.create role_id: @role.id, permission_id: id
      end
      
      # Un-default other roles if necessary
      if @role.default
        Role.where.not(id: @role.id).update_all(default: false)
      end
      
      redirect_to action: 'index', notice: 'Role was successfully updated.'
    else
      render 'edit'
    end
  end

  def destroy
    @role = authorize Role.find(params[:id])
    @role.destroy
    
    redirect_to action: 'index', notice: 'Role has been deleted.'
  end
  
  
  private
  
    def role_params
      params.require(:role).permit(:name, :default, :super_user, :about)
    end
  
  
end
