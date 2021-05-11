class BooksService
  def borrow(user_id, book_id)
    books_transaction = nil
    Book.transaction do
      BooksTransaction.transaction do
        user = User.find(user_id)
        book = Book.lock(true).find(book_id)
        raise BooksException, "Book #{book_id} count should > 1" if book.count < 1
        raise BooksException, "User #{user_id} amount than 1" if user.amount < 1

        # create BooksTransaction
        books_transaction = BooksTransaction.create!(
          user: user,
          book: book,
          from_count: book.count,
          option: :out,
          to_count: book.count - 1
        )
        book.count -= 1
        book.save!
      end
    end
    books_transaction
  end

  def return(user_id, book_id, cost)
    raise BooksException, 'cost must be integer' unless cost.class.to_s == 'Integer'
    raise BooksException, 'cost must must be greater than or equal to' if cost < 0

    new_books_transaction = nil
    User.transaction do
      Book.transaction do
        BooksTransaction.transaction do
          user = User.lock(true).find(user_id)
          book = Book.lock(true).find(book_id)
          parent_books_transaction = BooksTransaction.lock(true)
                                                     .where(
                                                       book_id: book_id,
                                                       user_id: user_id,
                                                       option: :out,
                                                       status: :no_returned
                                                     ).first
          raise BooksException, "book #{book_id} is already return" unless parent_books_transaction.present?
          if user.amount <= cost
            raise BooksException, "User #{user_id} amount should be greater than or equal to cost: #{cost}"
          end

          # return book
          parent_books_transaction.return!

          # create new BooksTransaction
          new_books_transaction = BooksTransaction.create!(
            user: user,
            book: book,
            parent_id: parent_books_transaction.id,
            from_count: book.count,
            to_count: book.count + 1,
            option: :back,
            status: :returned
          )
          book.count += 1

          # create UserAmountTransaction
          user_amount_transaction = UserAmountTransaction.create(
            user: user,
            option: :borrow_book,
            books_transaction: new_books_transaction,
            amount: cost,
            from_amount: user.amount,
            to_amount: user.amount - cost
          )
          user.amount -= cost
          user.save!
          book.total_income += cost
          book.save!
        end
      end
    end
    new_books_transaction
  end
end
