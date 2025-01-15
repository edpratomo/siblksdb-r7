class ApplicationController < ActionController::Base
  include Pundit::Authorization
  
  #before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  layout :set_layout

  def set_layout
    if current_user
      'application'
    else
      #'devise'
      'plain'
    end
  end

  # http://stackoverflow.com/questions/2139996/how-to-redirect-to-previous-page-in-ruby-on-rails
  def store_location
    return unless request.get?
    if (controller_name != "sessions" and
        controller_name != "password_resets" and
        controller_name != "users" and
        !request.xhr?) # don't store ajax calls
      session[:return_to] = request.fullpath
    end
  end

  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
  end

end
