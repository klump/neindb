require 'rails_helper'

RSpec.describe Api::V1::BaseController, type: :controller do
  describe '#authenticate_with_token' do
    before(:each) do
      @user = FactoryGirl.create(:user)
    end

    context 'with valid credentials' do
      it 'logs the user in' do
        @request.headers['Authorization'] = "#{@user.username}+#{@user.auth_token}" 

        @controller.send(:authenticate_with_token)

        expect(@controller.send(:current_user)).to eq(@user)
      end
    end
    context 'with invalid credentials' do
      it 'raises an User::Unauthorized exception' do
        @request.headers['Authorization'] = 'something+invalid'

        expect {@controller.send(:authenticate_with_token)}.to raise_error(User::Unauthorized)
      end
    end
  end
end
