class RegistrationsController < Devise::RegistrationsController

  before_filter :configure_permitted_parameters

  # override the create method here to update our year_text value on the user record create
  def create
    super do
      resource.year_text = resource.get_year_text
      resource.save
    end
  end



  protected

# my custom fields are :name, :heard_how
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) {|u| u.permit(:email,:password,:password_confirmation,:username,:first_name,:last_name,:dob,:class_of)}
    devise_parameter_sanitizer.for(:account_update) {|u| u.permit(:email,:password,:password_confirmation,:username,:first_name,:last_name,:dob,:class_of)}
  end

end