require 'spec_helper'

describe Api::V1::UsersController, type: :controller do
  let(:link) { create(:link) }
  let(:user) { create(:user) }

  describe "#show" do
 
    context "with a valid request url" do
      let(:json) { JSON.parse(response.body, symbolize_names: true) }

      before do
        link.update_attributes(user_id: user.id)
        get :show, api_key: user.api_key, id: link.short_url, format: :json
      end

      it "returns a JSON response" do
        expect(response.content_type).to eq "application/json"
      end

      it "returns a name" do
        expect(json.keys).to include :name
        expect(json[:name]).to include assigns(:user).name
      end

      it "returns an email" do
        expect(json.keys).to include :email
        expect(json[:email]).to include assigns(:user).email
      end

      it "returns links belonging to the user" do
        expect(json.keys).to include :links
      end

      it "returns a short_url" do
        expect(json[:links].first.keys).to include :short_url
        expect(json[:links].first[:short_url]).to include link.short_url
      end

      it "returns a long_url" do
        expect(json[:links].first.keys).to include :long_url
        expect(json[:links].first[:long_url]).to include link.long_url
      end

      it "returns number of clicks" do
        expect(json[:links].first.keys).to include :clicks
        expect(json[:links].first[:clicks]).to eq(link.clicks)
      end
    end
  end
end
