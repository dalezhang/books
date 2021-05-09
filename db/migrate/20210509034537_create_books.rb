class CreateBooks < ActiveRecord::Migration[6.0]
  def change
    create_table :books do |t|
      t.string :name
      t.integer :count, default: 0
      t.integer :total_income, default: 0
      t.timestamps null: false
    end
  end
end
