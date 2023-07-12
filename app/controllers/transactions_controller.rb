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
    raise StandardError  => "Transaction date cannot be greater than the current date" if confirm_date_transaction(transaction_params["date"]) 
    
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
    raise InvalidDate => "Transaction date cannot be greater than the current date" if confirm_date_transaction(transaction_params["date"]) 

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
    set_user
    file = params[:file]
    return redirect_to transactions_path, notice: "Only CSV, please" unless file.content_type == "text/csv"

    file = File.open(file)
    csv = CSV.readlines(file).to_a
    
    return redirect_to transactions_path, notice: "O cabeçalho da tabela deve conter somente as seguintes colunas ['input_type', 'date', 'value', 'installments', 'tag_id']" if confirm_header(csv.first)
    
    HardJob.perform_async(@user.id, csv.first, csv.drop(1))

    redirect_to transactions_path, notice: "Import done!"
  end

  # def perform(header, table)
  #   table.each do |row|
  #     transaction_hash = Hash[header.zip(row)]
  #     transaction_hash["tag_id"] = Tag.find_by(subcategory: transaction_hash["tag_id"]).id
  #     transaction_hash["user_id"] = current_user.id
  #     Transaction.create(transaction_hash)
  #   end
  # end

  private
    def confirm_header(header)
      true_header = ["input_type", "date", "value", "installments", "tag_id"]
      return true if header - true_header != true_header - header
    end

    def confirm_date_transaction(date) 
      return Date.parse(date) > Date.today unless date == nil
      false
    end

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
