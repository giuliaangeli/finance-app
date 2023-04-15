class CreateTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :transactions do |t|
      t.string :input_type
      t.date :date
      t.float :value
      t.integer :installments
      t.string :category
      t.string :subcategory

      t.timestamps
    end
  end
end
