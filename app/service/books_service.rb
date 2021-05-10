class BooksService
  COST = 1
  def borrow(user_id, book_id)
    Book.transaction do
      BooksTransaction.transaction do
        user = User.find(user_id)
        book = Book.lock(true).find(book_id)
        raise BooksException, "user #{user_id} amount should > 0" if user.amount < COST
        raise BooksException, "Book #{book_id} count should > 1" if book.count < 1

        # create BooksTransaction
        books_transaction = BooksTransaction.create(
          user: user,
          book: book,
          from_count: book.count,
          to_count: book.count - 1
        )
        book.count -= 1
        book.save!
      end
    end
  end

  def return(user_id, book_id)
    User.transaction do
      Book.transaction do
        BooksTransaction.transaction do
          user = User.lock(true).find(user_id)
          book = Book.lock(true).find(book_id)
          parent_books_transaction = BooksTransaction.lock(true)
                                                     .where(
                                                       book_id: book_id,
                                                       user_id: user_id,
                                                       status: :no_returned
                                                     ).first
          raise BooksException, "book #{book_id} is already return" unless parent_books_transaction.present?

          # return book
          parent_books_transaction.return!

          # create new BooksTransaction
          new_books_transaction = BooksTransaction.create(
            user: user,
            book: book,
            parent_id: parent_books_transaction.id,
            from_count: book.count,
            to_count: book.count + 1,
            status: :returned
          )
          book.count += 1

          # create UserAmountTransaction
          user_acount_transacton = UserAmountTransaction.create(
            user: user,
            option: :borrow_book,
            books_transaction: new_books_transaction,
            from_amount: user.amount,
            to_amount: user.amount - COST
          )
          user.amount = user_acount_transacton.to_amount
          user.save!
          book.total_income += 1
          book.save!
        end
      end
    end
  end
end
