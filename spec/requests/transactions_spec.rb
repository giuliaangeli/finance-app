require 'rails_helper'

RSpec.describe "Transactions", type: :request do
  describe "GET /index" do
    context "an account without transactions"
      it "does not show transactions" do
        get :index
        expect(response.code).to eq("200")
        expect(assigns(:transaction).to_a).to match_array([])
      end
    end

    context "an account with transactions"
    end
    pending "add some examples (or delete) #{__FILE__}"
  end
end
