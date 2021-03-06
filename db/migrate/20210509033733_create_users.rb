# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email,              null: false, default: ""
      t.string :token
      t.integer :amount, default: 0

      t.timestamps null: false
    end

    add_index :users, :email,                unique: true
  end

end
