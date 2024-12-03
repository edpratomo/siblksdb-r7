class ApplicationController < ActionController::Base
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

end
