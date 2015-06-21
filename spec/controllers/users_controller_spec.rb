require 'rails_helper'

RSpec.describe UsersController, :type => :controller do

  describe "GET upload_form" do
    it "returns http success" do
      get :upload_form
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET upload_post" do
    it "returns http success" do
      get :upload_post
      expect(response).to have_http_status(:success)
    end
  end

end
