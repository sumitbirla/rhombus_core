class Admin::System::RolesController < Admin::BaseController
  
  def index
    authorize Role
    @roles = Role.order(:name)
    
    respond_to do |format|
      format.html { @roles = @roles.paginate(page: params[:page], per_page: @per_page) }
      format.csv { send_data Role.to_csv(@roles) }
    end
  end

  def new
    @role = Role.new
    authorize @role
    render 'edit'
  end

  def create
    @role = Role.new(role_params)
    authorize @role
    
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
    @role = Role.find(params[:id])
    authorize @role
  end

  def edit
    @role = Role.find(params[:id])
    authorize @role
  end

  def update
    @role = Role.find(params[:id])
    authorize @role
    
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
    @role = Role.find(params[:id])
    authorize @role
    @role.destroy
    
    redirect_to action: 'index', notice: 'Role has been deleted.'
  end
  
  
  private
  
    def role_params
      params.require(:role).permit(:name, :default, :super_user, :about)
    end
  
  
end
