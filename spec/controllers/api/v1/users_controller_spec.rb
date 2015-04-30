require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  configure_api version: 1

  it_requires_authentication

  # authenticate the user
  before(:each) do
    @user = FactoryGirl.create(:admin)
    @request.headers['Authorization'] = "#{@user.username}+#{@user.auth_token}"
  end

  describe 'GET #show' do
    context 'when the requesting user is an admin' do
      context 'and the user exists' do
        before(:each) do
          # the @user variable is already set by the before(:each) block for authentication
          get :show, id: @user.id, format: :json
        end

        it 'responds with a HTTP 200 status code' do
          expect(response).to be_success
        end

        it 'loads the information about a user into @user' do
          expect(assigns(:user)).to eql @user
        end
      end

      context 'and the user does not exist' do
        before(:each) do
          get :show, id: 42, format: :json
        end

        it 'responds with a HTTP 404 status code' do
          expect(response).to have_http_status(404)
        end

        it 'returns some error message' do
          json = JSON.parse(response.body, symbolize_names: true)

          expect(json).to have_key(:error)
        end
      end
    end
    context 'when the requesting user is not an admin' do
      before(:each) do
        @user = FactoryGirl.create(:user)
        @request.headers['Authorization'] = "#{@user.username}+#{@user.auth_token}"
      end

      it 'should allow access to the user himself' do
        get :show, id: @user.id, format: :json

        expect(assigns(:user)).to eql @user
      end

      it 'should deny access to other users' do
        other_user = FactoryGirl.create(:user)

        get :show, id: other_user.id, format: :json

        expect(response).to have_http_status(403)
      end
    end
  end
end
