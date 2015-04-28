module NeinDbApiMacros
  def configure_api options
    before(:each) do
      @request.headers['X-Nein-API-Version'] = options[:version]
      @request.headers['Accept'] = :json
    end
  end

  def api_login_as role
    before(:each) do
      @user = FactoryGirl.create(role)
      @request.headers['Authorization'] = "#{@user.username}+#{@user.auth_token}"
    end
  end
end
