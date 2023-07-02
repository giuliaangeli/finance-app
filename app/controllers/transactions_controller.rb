class TransactionsController < ApplicationController
  require "csv"

  before_action :set_user
  before_action :set_transaction, only: %i[ edit update destroy ]

  # GET /transactions or /transactions.json
  def index
    @transactions = @user.transactions.all
    @tag = Tag.all
  end

  # GET /transactions/new
  def new
    @transaction = @user.transactions.new
  end

  # GET /transactions/1/edit
  def edit
  end

  # POST /transactions or /transactions.json
  def create
    @transaction = @user.transactions.new(transaction_params)
    
    respond_to do |format|
      if @transaction.save
        format.html { redirect_to transactions_url(@user), notice: "Transaction was successfully created." }
        format.json { render :index, status: :created, location: @transaction }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /transactions/1 or /transactions/1.json
  def update
    respond_to do |format|
      if @transaction.update(transaction_params)
        format.html { redirect_to transactions_url(@user), notice: "Transaction was successfully updated." }
        format.json { render :index, status: :ok, location: @transaction }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /transactions/1 or /transactions/1.json
  def destroy
    @transaction.destroy

    respond_to do |format|
      format.html { redirect_to transactions_url(@user), notice: "Transaction was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def import
    file = params[:file]
    return redirect_to transactions_path, notice: "Only CSV, please" unless file.content_type == "text/csv"

    file = File.open(file)
    csv = CSV.readlines(file, headers: true, col_sep: ',')
    csv.each do |row|
      transaction_hash = {}
      transaction_hash[:input_type] = row['input_type']
      transaction_hash[:date] = row['date']
      transaction_hash[:value] = row['value'].to_i.abs
      transaction_hash[:installments] = row['installments']
      transaction_hash[:tag_id] = find_tag_id(row['subcategory'])
      transaction_hash[:user_id] = current_user.id
      Transaction.create(transaction_hash)
    end
    redirect_to transactions_path, notice: "Import done!"
  end

  def find_tag_id(subcategory)
    Tag.find_by(subcategory: subcategory).id
  end

  private
    def set_user
      @user = current_user
    end
    
    # Use callbacks to share common setup or constraints between actions.
    def set_transaction
      @transaction = Transaction.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def transaction_params
      params.require(:transaction).permit(:input_type, :date, :value, :installments, :tag_id)
    end
end
