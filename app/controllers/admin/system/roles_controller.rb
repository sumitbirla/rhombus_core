class Admin::System::RolesController < Admin::BaseController
  
  def index
    @roles = Role.all
  end

  def new
    @role = Role.new
    render 'edit'
  end

  def create
    @role = Role.new(role_params)
    
    if @role.save
      
      # Save permissions
      params[:permission_ids].each do |id|
        RolePermission.create role_id: @role.id, permission_id: id
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
  end

  def edit
    @role = Role.find(params[:id])
  end

  def update
    @role = Role.find(params[:id])
    
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
    @role.destroy
    redirect_to action: 'index', notice: 'Role has been deleted.'
  end
  
  
  private
  
    def role_params
      params.require(:role).permit(:name, :default, :super_user, :about)
    end
  
  
end
