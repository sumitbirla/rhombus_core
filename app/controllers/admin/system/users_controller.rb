class Admin::System::UsersController < Admin::BaseController
  skip_before_filter :require_login, only: :password_reset

  def index
    authorize User.new
    @users = User.where(domain_id: cookies[:domain_id])
                 .includes(:role)
                 .joins(:role)
                 .order(sort_column + " " + sort_direction)
                 
    @users = @users.where("core_users.name LIKE '%#{params[:q]}%' OR email LIKE '%#{params[:q]}%'") unless params[:q].nil?
    @users = @users.where(status: params[:status]) unless params[:status].blank?
    @users = @users.where(role_id: params[:role_id]) unless params[:role_id].blank?
    
    #  DOES NOT WORK   authorize(@users)
    
    respond_to do |format|
      format.html  { @users = @users.paginate(page: params[:page], per_page: @per_page) }
      format.csv { send_data User.to_csv(@users, skip_cols: ["password_digest"]) }
    end
  end

  def new
    @user = User.new(
                  name: 'New user', 
                  domain_id: Rails.configuration.domain_id,
                  time_zone: Cache.setting(Rails.configuration.domain_id, :system, 'Time Zone'),
                  role_id: Role.find_by(default: true).id, 
                  referral_key: SecureRandom.hex(5), 
                  status: :active )
                  
    authorize @user
    render 'edit'
  end

  def create
    @user = authorize User.new(user_params)
    @user.password_digest = BCrypt::Password.create(params[:password]) unless params[:password].blank?
    
    if @user.save
      redirect_to action: 'show', id: @user.id, notice: 'User was successfully created.'
    else
      render 'edit'
    end
  end

  def show
    @user = authorize User.find(params[:id])
    @counts = get_counts(@user)
  end

  def edit
    @user = authorize User.find(params[:id])
  end

  def update
    @user = authorize User.find(params[:id])

    if @user.update(user_params)
      # update password if needed
      unless params[:password].blank?
        @user.password_digest = BCrypt::Password.create(params[:password])
        @user.save
      end
      
      if @user.referral_key.blank?
        @user.referral_key = SecureRandom.hex(5)
        @user.save
      end
      
      redirect_to action: 'show', id: @user.id, notice: 'User was successfully updated.'
    else
      render 'edit'
    end
  end

  def destroy
    @user = authorize User.find(params[:id])
    @user.destroy
    redirect_to action: 'index', notice: 'User has been deleted.'
  end
  
  def extra_properties
    @user = User.find(params[:id])
    authorize @user, :show?
    5.times { @user.extra_properties.build }
  end
  
  def orders
    @user = User.find(params[:id])
    authorize @user, :show?
    @orders = Order.where(user_id: @user.id, status: Order.valid_statuses).paginate(page: params[:page], per_page: 10).order('created_at DESC')

    @counts = get_counts(@user)
  end

  def packages
    @user = User.find(params[:id])
    authorize @user, :show?
    @user_packages = UserPackage.where(user_id: @user.id).paginate(page: params[:page], per_page: 10).order('created_at DESC')

    @counts = get_counts(@user)
  end

  def payment_methods
    @user = User.find(params[:id])
    authorize @user, :show?
    @payment_methods = PaymentMethod.where(user_id: @user.id).paginate(page: params[:page], per_page: 10).order('created_at DESC')

    @counts = get_counts(@user)
  end

  def locations
    @user = User.find(params[:id])
    authorize @user, :show?
    @locations = Location.where(user_id: @user.id).paginate(page: params[:page], per_page: 10).order('created_at DESC')

    @counts = get_counts(@user)
  end

  def cases
    @user = User.find(params[:id])
    authorize @user, :show?
    @cases = Case.where(user_id: @user.id).paginate(page: params[:page], per_page: 10).order('created_at DESC')

    @counts = get_counts(@user)
  end

  def vouchers
    @user = User.find(params[:id])
    authorize @user, :show?
    @vouchers = UserVoucherHistory.where(user_id: @user.id).paginate(page: params[:page], per_page: 10).order('created_at DESC')

    @counts = get_counts(@user)
  end

  def create_voucher
    authorize User, :update?
    UserVoucherHistory.create(user_id: params[:id], amount: params[:amount], notes: params[:notes])
    redirect_to :back
  end

  def pictures
    @user = User.find(params[:id])
    authorize @user, :show?
    @pictures = Picture.where(user_id: @user.id).paginate(page: params[:page], per_page: 10).order('created_at DESC')

    @counts = get_counts(@user)
  end

  def login
    reset_session
    session[:user_id] = params[:id]
    redirect_to root_path
  end
  
  def welcome_email
    begin
      user = User.find(params[:id])
      UserMailer.welcome_email(user).deliver_now
      flash[:info] = "Welcome email sent to #{user.email}"
    rescue => e
      flash[:error] = e.message
    end
    
    redirect_to :back
  end

  def password_reset
    render 'password_reset', layout: 'admin/layouts/dialog'
  end


  def get_counts(user)
    #num_orders = Order.where(user_id: user.id, status: Order.valid_statuses).count
    #num_packages = UserPackage.where(user_id: user.id).count
    #num_locations = Location.where(user_id: user.id).count
    #num_payment_methods = PaymentMethod.where(user_id: user.id).count
    #num_cases =  Case.where(user_id: user.id).count
    #num_vouchers =  UserVoucherHistory.where(user_id: user.id).count
    #num_pictures = Picture.where(user_id: user.id).count

    h = {}
    #h[:orders] = '(' + num_orders.to_s + ')' if num_orders > 0
    #h[:packages] = '(' + num_packages.to_s + ')'  if num_packages > 0
    #h[:locations] = '(' + num_locations.to_s + ')'  if num_locations > 0
    #h[:payment_methods] = '(' + num_payment_methods.to_s + ')'  if num_payment_methods > 0
    #h[:cases] = '(' + num_cases.to_s + ')'  if num_cases > 0
    #h[:vouchers] = '(' + num_vouchers.to_s + ')'  if num_vouchers > 0
    #h[:pictures] = '(' + num_pictures.to_s + ')'  if num_pictures > 0

    h
  end

  def random
    render :json => { random: SecureRandom.hex(5) }
  end
  
  
  private
  
    def user_params
      params.require(:user).permit!
    end
    
    def sort_column
      params[:sort] || "core_users.id"
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
    end
  
end
