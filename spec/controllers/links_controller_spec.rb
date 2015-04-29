require 'spec_helper'

describe LinksController, type: :controller do

  let(:link) { create(:link) }
  let(:user) { create(:user) }
  let(:attrs) { link.attributes }

  describe "#create" do
    it "changes count if long_url does not exist" do
      attrs[:long_url] = "http://yahoo.com"
      expect { post :create, link: attrs }.to change(Link, :count).by(1)
    end

    it "redirects if long_url exists" do
      post :create, link: attrs
      expect(response).to redirect_to link_path(link.short_url)
    end
  end

  describe "#create when signed in" do
    before do
      allow(self.controller).to receive(:current_user).and_return(user)
    end

    it "changes count if long_url does not exist" do
      attrs[:long_url] = "http://yahoo.com"
      expect { post :create, link: attrs }.to change(user.links, :count).by(1)
    end

    it "changes count if long_url exists" do
      post :create, link: attrs
      expect { post :create, link: attrs }.to change(user.links, :count).by(1)
    end

    it "tweets the url" do
      stub_tweet
      post :create, link: attrs.merge(tweet: '1')
      expect(WebMock).to have_requested(:post, /api.twitter.com/)
    end
  end

  describe "#show" do
    it "is successful" do
      get :show, id: link.short_url
      expect(response).to be_success
    end
  end

  describe "#redirection" do
    it "is successful" do
      get :redirection, id: link.short_url
      expect(response).to redirect_to link.long_url
    end
  end
end
