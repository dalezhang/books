# tables
* users
  * amount
  * name
* books
  * count
  * name
* books_transactions
  * user_id
  * book_id
  * parent_id (out transction id)
  * created_at
  * from_count
  * to_count
  * type (out: 1, back: 2)
* user_amount_transactions
  * user_id
  * books_transaction_id
  * from_amount
  * to_amount
  * option (borrow_book, recharge)

