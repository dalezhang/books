class AddFreezeAmountToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :freeze_amount, :integer, default: 0
  end
end
