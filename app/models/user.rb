class User < ApplicationRecord
  INIRIAL_AMOUNT = 1000
  has_many :books_transactions
  has_many :books, through: :books_transactions
  has_many :user_amount_transactions
  before_create :set_initial_amount
  validates :amount, numericality: { greater_than_or_equal_to: 0 }

  def unreturnd_books_transactions
    books_transactions.where(books_transactions: { status: :no_returned })
  end

  private

  def set_initial_amount
    self.amount = INIRIAL_AMOUNT if amount < 1
  end
end
