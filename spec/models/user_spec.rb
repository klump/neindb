require 'rails_helper'

describe User, type: :model do
  before { @user = FactoryGirl.build(:user) }
  subject { @user }

  describe "#generate_auth_token" do
    it "generates a unique token" do
      # fake the return value of Base64.urlsafe_encode64 to always return a fixed string 
      allow(Base64).to receive(:urlsafe_encode64).and_return('4PbXV8BoguqZXDq-rEyVYYqzbksj91tG-3UqEFEeJRkiYd2Gl9u0KEAXji2JA1r68Hl9HDyt5A7_D7oxs0QYxg==')

      @user.generate_auth_token

      expect(@user.auth_token).to eql '4PbXV8BoguqZXDq-rEyVYYqzbksj91tG-3UqEFEeJRkiYd2Gl9u0KEAXji2JA1r68Hl9HDyt5A7_D7oxs0QYxg=='
    end

    it "generates a new token if the token is already be issued" do
      existing_user = FactoryGirl.create(:user, auth_token: "a_unique_token_123")
      
      @user.generate_auth_token

      expect(@user.auth_token).not_to eql existing_user.auth_token
    end

    it "generates a new token for new users" do
      user = FactoryGirl.build(:user)

      expect(user.auth_token).to be_empty

      user.save

      expect(user.auth_token).not_to be_empty
    end
  end
end
