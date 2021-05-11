class RmFreezeAmountFromUser < ActiveRecord::Migration[6.0]
  def change
    remove_column :users, :freeze_amount
  end
end
