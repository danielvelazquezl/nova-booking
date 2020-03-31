class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?
  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :email, :password, :password_confirmation])
    devise_parameter_sanitizer.permit(:sign_in, keys: [:login, :password, :password_confirmation])
    devise_parameter_sanitizer.permit(:account_update, keys: [:username, :email, :password, :password_confirmation, :current_password])
  end

  #Excepcion de acceso denegado.
  rescue_from CanCan::AccessDenied do |exception|
      respond_to do |format|
        format.json { head :forbidden }
        format.html { redirect_to welcome_index_path, :alert => 'Acesso denegado.' }
      end
  end
end
