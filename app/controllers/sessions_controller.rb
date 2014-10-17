# app/controllers/sessions_controller.rb

class SessionsController < Devise::SessionsController

  def create
    resource = warden.authenticate!(:scope => resource_name, :recall => "#{controller_path}#failure")
    sign_in_and_redirect(resource_name, resource)
  end

  def sign_in_and_redirect(resource_or_scope, resource=nil)
    scope = Devise::Mapping.find_scope!(resource_or_scope)
    resource ||= resource_or_scope
    sign_in(scope, resource) unless warden.user(scope) == resource
    render :json => [{:success => true}, resource]
  end

  def failure
    render :json => {:errors => {"Invalid Data" => "Login Failed"}}, status: :unprocessable_entity
  end

  def destroy
    sign_out(resource_name)
    render json: {
        success:true
    }
  end
end