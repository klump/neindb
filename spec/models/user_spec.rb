require 'rails_helper'

describe User, type: :model do
  before { @user = FactoryGirl.build(:user) }
  subject { @user }

  describe "#generate_auth_token" do
    it "generates a unique token" do
      # fake Devise, so that Devise.friendly_token returns a fixed value
      allow(Devise).to receive(:friendly_token).and_return("a_unique_token_123")

      @user.generate_auth_token

      expect(@user.auth_token).to eql "a_unique_token_123"
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
