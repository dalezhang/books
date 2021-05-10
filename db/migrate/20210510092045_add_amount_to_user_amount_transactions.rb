class AddAmountToUserAmountTransactions < ActiveRecord::Migration[6.0]
  def change
    add_column :user_amount_transactions, :amount, :integer, default: 0
  end
end
