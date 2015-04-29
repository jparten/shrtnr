module SessionsHelper

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def signed_in?
    !current_user.nil?
  end

  def signed_in_through_twitter?
    current_user && !current_user.uid.blank?
  end

  def authentication_required
    unless signed_in?
      store_location
      redirect_to login_url, notice: "Please sign in"
    end
  end

  def redirect_back_or(default, msg={})
    redirect_to((session[:return_to] || default), msg)
    session.delete(:return_to)
  end

  def store_location
    session[:return_to] = request.url if request.get?
  end
end
