class CreateUserAmountTransactions < ActiveRecord::Migration[6.0]
  def change
    create_table :user_amount_transactions do |t|
      t.integer :user_id, null: false
      t.integer :books_transaction_id
      t.integer :from_amount, default: 0
      t.integer :to_amount, default: 0
      t.integer :option, default: 0, commit: 'borrow_book: 1, recharge: 2'
      t.timestamps null: false
    end
  end
end
