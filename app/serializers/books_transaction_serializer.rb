class BooksTransactionSerializer < ActiveModel::Serializer
  attributes :id, :from_count, :to_count, :option,
    :created_at, :updated_at, :status, :parent_id,
    :book_id

  has_one :book
  has_one :user
end
