class UserAmountTransaction < ApplicationRecord
  belongs_to :user
  belongs_to :books_transaction
  enum option: {
    borrow_book: 1,
    recharge: 2
  }
end
