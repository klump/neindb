module ControllerMacros 
  # Role is a symbol of the role the users logs in as
  def login_as role
    before(:each) do
      @user = FactoryGirl.create(role)
      sign_in @user
    end
  end

  def it_requires_authentication
    crud = {
      index: [:get],
      show: [:get],
      new: [:get],
      edit: [:get],
      create: [:post],
      update: [:put, :patch],
      destroy: [:delete]
    }

    it_requires_authentication_for crud
  end

  def it_requires_authentication_for resources
    context 'when not authenticated' do
      resources.each do |resource,verbs| 
        verbs.each do |verb|
          it "it refuses access to #{verb.to_s.upcase} ##{resource.to_s}" do
            # invalidate both the devise authorization and the authorization token for the api
            sign_out :user
            @request.headers['Authorization'] = nil

            # Options for the requests
            options = {}
            if @request.format == :json
              options = { format: :json }
            end

            begin
              case verb
              when :get
                get resource, options
              when :post
                post resource, options
              when :put
                put resource, options
              when :patch
                patch resource, options
              when :delete
                delete resource, options
              end
            rescue ActionController::UrlGenerationError
              # Catch errors for nonexisting routes
            else
              if request.format == :json
                # API responses should have an approriate HTTP status code
                expect(response).to have_http_status(401)
              else
                # Normal web responses should redirect unauthenticated requests to the login page
                expect(response).to redirect_to(new_user_session_url)
              end
            end
          end
        end
      end
    end
  end

  def it_requires_role role
    it "permits access for users with authorized role" do
      user = FactoryGirl.create(role)
      sign_in user

      if request.format == :json
        # API requests should be in JSON format
        get :index, format: :json
      else
        get :index
      end
      
      expect(response).to be_success
    end
    it "denies access for users with unauthorized role" do
      # get the role below the required one
      index = User::ROLES.index(role.to_s) - 1
      if index >= 0
        new_role = User::ROLES[index].to_sym
        user = FactoryGirl.create(new_role)
        sign_in user

        if request.format == :json
          # API requests should be in JSON format
          get :index, format: :json

          # API responses should have an approriate HTTP status code
          expect(response).to have_http_status(403)
        else
          get :index
          # Normal web responses should redirect unauthorized requests to the start page
          expect(response).to redirect_to(root_url)
        end
      end
    end
  end
end
