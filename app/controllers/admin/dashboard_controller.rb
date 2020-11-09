class Admin::DashboardController < Admin::BaseController

  def index
  end

  def clear_cache
    flash[:info] = Rails.cache.clear.length.to_s + " items cleared."
    redirect_back(fallback_location: admin_root_path)
  end

end
