class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  # before_action :set_sidebar_data, unless: :devise_controller?

  private

  def set_sidebar_data
    # ... existing code ...
  end
end
