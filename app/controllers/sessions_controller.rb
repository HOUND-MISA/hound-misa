class SessionsController < Devise::SessionsController
  # POST /resource/sign_in
  def create
    auth_options = {:recall => 'pages#fail', :scope => resource_name}
    self.resource = warden.authenticate!(auth_options)
    set_flash_message(:notice, :signed_in) if is_flashing_format?
    sign_in(resource_name, resource)
    yield resource if block_given?
    
  end

end