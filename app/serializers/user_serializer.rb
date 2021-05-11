class UserSerializer < ActiveModel::Serializer
  attributes :id, :total_amount, :freeze_amount, :name, :email

  has_many :unreturnd_books_transactions
  has_many :user_amount_transactions

  def total_amount
    object.amount + object.freeze_amount
  end
end
