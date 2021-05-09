class UserSerializer < ActiveModel::Serializer
  attributes :id, :amount, :name, :email

  has_many :unreturnd_books
  has_many :user_amount_transactions

end
