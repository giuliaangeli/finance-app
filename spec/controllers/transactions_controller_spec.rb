require "rails_helper"

RSpec.describe TransactionsController, type: :controller do
  let!(:user) { FactoryBot.create(:default_user) }
  let(:transaction_valid) { FactoryBot.create(:transaction_valid_attributes) }
  let(:transaction_invalid) { FactoryBot.create(:transaction_invalid_attributes) }
  
  before do
    sign_in user
  end

  describe "GET #index" do
    it "assigns all transactions to @transactions" do
      get :index, params: { user_id: user.id }
      expect(assigns(:transactions)).to eq(user.transactions)
    end

    it "assigns all tags to @tag" do
      get :index, params: { user_id: user.id }
      expect(assigns(:tag)).to eq(Tag.all)
    end
  end

  describe "GET #new" do
    it "assigns a new transaction to @transaction" do
      get :new, params: { user_id: user.id }
      expect(assigns(:transaction)).to be_a_new(Transaction)
    end
  end

  describe "GET #edit" do
    it "assigns the requested transaction to @transaction" do
      get :edit, params: { id: transaction_valid.id, user_id: user.id }
      expect(assigns(:transaction)).to eq(transaction_valid)
    end
  end

  describe "POST #create" do
    context "with valid parameters" do
      it "creates a new transaction" do
        expect {
          post :create, params: { user_id: user.id, transaction: attributes_for(:transaction_valid_attributes) }
        }.to change(Transaction, :count).by(1)
      end

      it "redirects to the transactions index page" do
        post :create, params: { user_id: user.id, transaction: attributes_for(:transaction_valid_attributes) }
        expect(response).to redirect_to(transactions_url(user))
      end
    end

    context "with invalid parameters" do
      it "render error - invalid date" do
        expect {
          post :create, params: { user_id: user.id, transaction: attributes_for(:transaction_invalid_attributes, date: Date.today + 1.day) }
        }.to raise_error(StandardError)
      end
    end
  end

  describe "PATCH #update" do
    context "with valid parameters" do
      it "updates the requested transaction" do
        patch :update, params: { id: transaction_valid.id, user_id: user.id, transaction: { value: 100 } }
        transaction_valid.reload
        expect(transaction_valid.value).to eq(100)
      end

      it "redirects to the transactions index page" do
        patch :update, params: { id: transaction_valid.id, user_id: user.id, transaction: { value: 100 } }
        expect(response).to redirect_to(transactions_url(user))
      end
    end

    context "with invalid parameters" do
      it "does not update the requested transaction" do
        old_value = transaction_valid.value
        patch :update, params: { id: transaction_valid.id, user_id: user.id, transaction: { tag_id: 47 } }
        transaction_valid.reload
        expect(transaction_valid.value).to eq(old_value)
      end

      it "renders the edit template" do
        patch :update, params: { id: transaction_valid.id, user_id: user.id, transaction: { tag_id: 47 } }
        expect(response).to render_template(:edit)
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested transaction" do
      delete :destroy, params: { id: transaction_valid.id, user_id: user.id }
      expect(Transaction.exists?(transaction_valid.id)).to be_falsey
    end

    it "redirects to the transactions index page" do
      delete :destroy, params: { id: transaction_valid.id, user_id: user.id }
      expect(response).to redirect_to(transactions_url(user))
    end
  end

  describe "POST #import" do
    context "with a CSV file" do
      let(:csv_file) { fixture_file_upload("transactions.csv", "text/csv") }

      it "imports the transactions from the CSV file" do
        expect(HardJob).to receive(:perform_async).with(user.id, an_instance_of(Array), an_instance_of(Array))
        post :import, params: { user_id: user.id, file: csv_file }
      end

      it "redirects to the transactions index page" do
        post :import, params: { user_id: user.id, file: csv_file }
        expect(response).to redirect_to(transactions_url)
      end

      it "displays a success notice" do
        post :import, params: { user_id: user.id, file: csv_file }
        expect(flash[:notice]).to eq("Import done!")
      end
    end

    context "with a non-CSV file" do
      let(:non_csv_file) { fixture_file_upload("document.png", "application/png") }

      it "does not import the transactions" do
        expect(HardJob).not_to receive(:perform_async)
        post :import, params: { user_id: user.id, file: non_csv_file }
      end

      it "redirects to the transactions index page" do
        post :import, params: { user_id: user.id, file: non_csv_file }
        expect(response).to redirect_to(transactions_url)
      end

      it "displays an error notice" do
        post :import, params: { user_id: user.id, file: non_csv_file }
        expect(flash[:notice]).to eq("Only CSV, please")
      end
    end
  end
end