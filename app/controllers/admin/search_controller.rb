class Admin::SearchController < Admin::BaseController

  def index

    return render 'index' if params[:q].nil?

    key, val = params[:q].split(' ', 2)

    return render 'index' if val.nil?

    spath = SearchPath.find_by(short_code: key)

    return redirect_to spath.url + "?q=" + val unless spath.nil?

  end

end
