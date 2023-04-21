class RegistrationsController < Devise::RegistrationsController
  before_action :configure_permitted_parameters, if: :devise_controller?
  skip_before_action :validate_login
  respond_to :json

  protected

  def sign_up(resource_name, resource)
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) do |user_params|
      user_params.permit(:first_name, :last_name, :email, :password, :password_confirmation)
    end
  end

  private

  def respond_with(resource, _opts={})
    render json: resource
    if resource.id.nil?
      head :unprocessable_entity
    else
      head :ok
    end
  end

end