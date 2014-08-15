class Admin::SearchController < Admin::BaseController

  def index

    return render 'index' if params[:q].nil?

    key, val = params[:q].split

    case key
      when 'p'
        return redirect_to admin_store_products_path(q: val)

      when 'upc'
        return redirect_to admin_store_upc_index_path(q: val)

      when 'u'
        return redirect_to admin_system_users_path(q: val)

      when 'o'
        return redirect_to admin_store_orders_path(q: val)

      when 'e'
        return redirect_to admin_marketing_email_subscribers_path(q: val)

      when 'loc'
        return redirect_to admin_cms_locations_path(q: val)

      when 'a'
        return redirect_to admin_system_affiliates_path(q: val)
    end
  end

end
