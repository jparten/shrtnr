require 'spec_helper'

describe SessionsController, type: :controller do

  let(:user) { User.create!(email: 'test@test.com', password: "Password",
                            password_confirmation: "Password")
  }

  describe "#direct" do
    it "redirects to dashboard_path if signed in" do
      allow(self.controller).to receive(:current_user).and_return(user)
      get :direct
      expect(response).to redirect_to(dashboard_path)
    end

    it "redirects to home_path if not signed in" do
      get :direct
      expect(response).to redirect_to(home_path)
    end

  end

  describe "#new" do
    it "is successfull" do
      get :new
      expect(response).to be_success
    end
  end

  describe "#create" do
    it "adds a User session" do
      post :create, email: user.email, password: user.password
      expect(session[:user_id]).to eq user.id
    end
  end

  describe "#twitter" do

    context "with invalid credentials" do
      before do
        OmniAuth.config.mock_auth[:twitter] = :invalid_credentials
        get :failure
      end

      it "redirects to root_url" do
        expect(response).to redirect_to(root_path)
      end

      it "has flash alert" do
        expect(flash[:alert]).to eq "Authentication Failed"
      end
    end

    context "with valid credentials" do
      before do
        OmniAuth.config.add_mock(:twitter, {
           uid: '12345',
           info: { nickname: 'test_user' },
           credentials: { token: "abc", secret: "123" }}
        )
        request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:twitter]
      end

      it "creates user unless user exists" do
        expect { get :twitter }.to change(User, :count).by(1)
      end

      it "signs in a user" do
        get :twitter
        expect(signed_in?).to be_truthy
      end

      it "has a flash notice" do
        get :twitter
        expect(flash[:notice]).to eq "You have been logged in through Twitter."
      end
    end
  end

  describe "#destroy" do

    before do
      post :create, email: user.email, password: user.password
      delete :destroy
    end

    it "deletes a User session" do
      expect(session[:user_id]).to be_nil
    end

    it "redirects to root_url" do
      expect(response).to redirect_to(root_url)
    end

    it "has flash notice" do
      expect(flash[:notice]).to eq "You have been logged out."
    end
  end
end
