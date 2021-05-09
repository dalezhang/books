class CreateBooksTransactions < ActiveRecord::Migration[6.0]
  def change
    create_table :books_transactions do |t|
      t.integer :user_id, null: false
      t.integer :book_id, null: false
      t.integer :parent_id, comment: 'out transction id'
      t.integer :from_count, default: 0
      t.integer :to_count, default: 0
      t.integer :option, default: 0, comment: 'out: 1, back: 2'
      t.integer :status, default: 0, commit: 'no_returned: 0, returned: 1'
      t.timestamps null: false
    end
  end
end
