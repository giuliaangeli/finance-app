class AddTagRefToTransactions < ActiveRecord::Migration[7.0]
  def change
    add_reference :transactions, :tag, null: true, foreign_key: true
  end
end
