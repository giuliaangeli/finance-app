class CreateTags < ActiveRecord::Migration[7.0]
  def change
    create_table :tags do |t|
      t.string :category
      t.string :subcategory

      t.timestamps
    end
  end
end
